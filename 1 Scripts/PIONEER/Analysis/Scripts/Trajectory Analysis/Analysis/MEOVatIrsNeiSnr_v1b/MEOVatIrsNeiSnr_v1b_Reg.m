%======================================================
% 
%======================================================

function [out,ANLZ] = MEOVatIrsNeiSnr_v1b_Reg(V,ANLZ,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
TF = INPUT.TF;
PSD = INPUT.PSD;
OB = INPUT.OB;
shapeval = V;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = TF.PROJdgn.fov;
vox = TF.PROJdgn.vox;
elip = TF.PROJdgn.elip;
vinvox0 = zf^3/PSD.kmatvol;
vinvox = ((vox/(fov/zf))^3)/elip;
if round(vinvox0*1e6) ~= round(vinvox*1e6)
    error
end

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(TF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = TF.tf;

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(ANLZ.zf,ANLZ.zf,ANLZ.zf);
b = (ANLZ.zf/2)+1-(psdmatwid-1)/2;
t = (ANLZ.zf/2)+1+(psdmatwid-1)/2;
psdzf(b:t,b:t,b:t) = PSD.psd;

%---------------------------------------------
% Build Object
%---------------------------------------------  
Status2('busy','Build Object',2);
obfunc = str2func([ANLZ.objectfunc,'_Func']);
INPUT.zf = zf;
INPUT.fov = fov;
INPUT.shapeval = shapeval;
[OB,err] = obfunc(OB,INPUT);
if err.flag
    msg = err.msg
    error
end
%figure(10); hold on; 
%OBprof = squeeze(OB.Ob(zf/2+1,zf/2+1,:));
%plot((OB.voxdim:OB.voxdim:fov),OBprof,'k'); 
%title('Object Profile');
%xlabel('Dimensions');
%xlim([0 fov]);

%---------------------------------------------
% FT
%---------------------------------------------
Status2('busy','Fourier Transform',2);
Im = fftshift(fftn(OB.Ob));
Im = Im.*tfzf;
clear tfzf
Im = ifftn(ifftshift(Im));
test = sum(imag(Im(:)));
if test > 1e-17
    test
    error
end
vinob = sum(OB.Ob(:));
nob = vinob/vinvox;
%figure(10);
%Improf1 = real(squeeze(Im(:,zf/2+1,zf/2+1)));
%Improf2 = real(squeeze(Im(zf/2+1,zf/2+1,:)));
%plot((OB.voxdim:OB.voxdim:fov),Improf1,'r'); plot((OB.voxdim:OB.voxdim:fov),Improf2,'r:');

%--------------------------------------
% Find ROI
%--------------------------------------    
Status2('busy','Find VOI at IRS',2);
INPUT.SmearIm = abs(Im);
ROI.aveirs = ANLZ.aveirs;
[ROI,err] = MaxVOIforAverageIRS_v1a(ROI,INPUT);
if err.flag
    error
end
if isnan(ROI.Mask)
    error;                          % starting value too small
end
vinROI = sum(ROI.Mask(:));
nroi = vinROI/vinvox;
%figure(10);
%ROIprof = squeeze(ROI.Mask(zf/2+1,zf/2+1,:));
%plot((OB.voxdim:OB.voxdim:fov),ROIprof,'b'); 
%legend('Base','In-Plane','Out-Of-Plane','ROI');

%---------------------------------------------
% Calculate CV
%---------------------------------------------    
Status2('busy','Noise Analysis',2);
INPUT.roi = ROI.Mask;
INPUT.psd = psdzf;
INPUT.kmatvol = PSD.kmatvol;  
CV = [];
[CV,err] = CorVolCalc_v1a(CV,INPUT);
if err.flag
    error
end
cv = CV.cv;
siv = nroi/cv;
rnei = 1.96*sqrt(1./siv)./ANLZ.snr

out = abs(rnei-ANLZ.rnei);

%---------------------------------------------
% Output
%--------------------------------------------- 
ANLZ.nob = nob;
ANLZ.nroi = nroi;
ANLZ.rneiout = rnei;
ANLZ.aveirsout = ROI.aveirsout;

Status2('done','',2);
Status2('done','',3);

