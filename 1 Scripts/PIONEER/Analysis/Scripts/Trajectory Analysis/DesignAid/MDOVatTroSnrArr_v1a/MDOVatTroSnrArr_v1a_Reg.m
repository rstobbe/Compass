%======================================================
% 
%======================================================

function [meov,ANLZ] = MDOVatTroSnrArr_v1a_Reg(V,ANLZ,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
PSD = INPUT.PSD;
PROJdgn = PSD.PROJdgn;
OB = INPUT.OB;
func = INPUT.func;
shapeval = V
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
zf = ANLZ.zf;
fov = PSF.PROJdgn.fov;
vox = PSF.PROJdgn.vox;
elip = PSF.PROJdgn.elip;
vinvox0 = zf^3/PSD.kmatvol;
vinvox = ((vox/(fov/zf))^3)/elip;
if round(vinvox0*1e6) ~= round(vinvox*1e6)
    error
end

%---------------------------------------------
% Zero-Fill Transfer Function
%---------------------------------------------
tfmatwid = length(PSF.tf);
tfzf = zeros(zf,zf,zf);
b = (zf/2)+1-(tfmatwid-1)/2;
t = (zf/2)+1+(tfmatwid-1)/2;
tfzf(b:t,b:t,b:t) = PSF.tf;

%---------------------------------------------
% Build Object
%---------------------------------------------  
Status2('busy','Build Object',2);
obfunc = str2func([ANLZ.objectfunc,'_Func']);
INPUT.zf = zf;
INPUT.fov = fov;
INPUT.shapeval = shapeval;
[OB,err] = obfunc(OB,INPUT);
clear INPUT;
if err.flag
    msg = err.msg
    error
end

%---------------------------------------------
% FT
%---------------------------------------------
Status2('busy','Fourier Transform',2);
Im = fftshift(fftn(OB.Ob));
Im = Im.*tfzf;
clear tfzf
Im = ifftn(ifftshift(Im));
test = sum(imag(Im(:)));
if test > 1e-20
    error
end
vinob = sum(OB.Ob(:));
clear OB;
nob = vinob/vinvox;

%--------------------------------------
% Find ROI
%--------------------------------------    
Status2('busy','Find VOI at IRS',2);
INPUT.SmearIm = abs(Im);
maxval = max(abs(Im(:)))
clear Im;
ROI.aveirs = 0.1;
[ROI,err] = MaxVOIforAverageIRS_v1a(ROI,INPUT);
clear INPUT;
if err.flag
    error
end
if isnan(ROI.Mask)
    meov = 0;                          
    return
end
vinROI = sum(ROI.Mask(:));
nroi = vinROI/vinvox;

if strcmp(func,'FindLB')
    meov = 1;
    return
end

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(ANLZ.zf,ANLZ.zf,ANLZ.zf);
b = (ANLZ.zf/2)+1-(psdmatwid-1)/2;
t = (ANLZ.zf/2)+1+(psdmatwid-1)/2;
psdzf(b:t,b:t,b:t) = PSD.psd;

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
snr = 1.96*sqrt(1./siv)./ANLZ.rnei
tro = PROJdgn.tro
nob = nob
meov = nob*(PROJdgn.vox^3)*(snr/18)

%---------------------------------------------
% Output
%--------------------------------------------- 
ANLZ.nob = nob;
ANLZ.nroi = nroi;
ANLZ.snr = snr;
ANLZ.vox = (PROJdgn.vox^3)*(snr/18);
ANLZ.rneiout = ANLZ.rnei;
ANLZ.aveirsout = ROI.aveirsout;
ANLZ.meov = meov;

Status2('done','',2);
Status2('done','',3);

