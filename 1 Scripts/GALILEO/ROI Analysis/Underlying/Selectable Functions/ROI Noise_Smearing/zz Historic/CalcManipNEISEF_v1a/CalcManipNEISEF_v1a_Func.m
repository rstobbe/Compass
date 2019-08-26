%=========================================================
% 
%=========================================================

function [OBCALC,err] = CalcManipNEISEF_v1a_Func(OBCALC,INPUT)

Status2('busy','Calculate NEI and SEF.  Manipulate ROI and return mean',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = OBCALC.PSF;
PSD = OBCALC.PSD;
CVCALC = OBCALC.CVCALC;
ROIMANIP = OBCALC.ROIMANIP;
ROI = INPUT.ROI;
OB = INPUT.OB;
PROJdgn = PSD.PROJdgn;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% ZeroFill PSF
%---------------------------------------------
sz = size(ROI.roimask);
tfmatwid = length(PSF.tf);
tfzf = zeros(sz);
b1 = (sz(1)/2)+1-(tfmatwid-1)/2;
t1 = (sz(1)/2)+1+(tfmatwid-1)/2;
b2 = (sz(2)/2)+1-(tfmatwid-1)/2;
t2 = (sz(2)/2)+1+(tfmatwid-1)/2;
b3 = (sz(3)/2)+1-(tfmatwid-1)/2;
t3 = (sz(3)/2)+1+(tfmatwid-1)/2;
tfzf(b1:t1,b2:t2,b3:t3) = PSF.tf;

%---------------------------------------------
% Calculate SEF
%---------------------------------------------
Status2('busy','Assess Image Smearing',3);
kmask = fftshift(fftn(double(OB.roimask)));
kmask = kmask.*tfzf;
SmearIm = ifftn(ifftshift(kmask));

test = sum(imag(SmearIm(:)));
if test > 1e-20
    error
end
SmearIm = real(SmearIm);
Status2('done','',3);

%---------------------------------------------
% ROI Manipulate
%---------------------------------------------
func = str2func([OBCALC.roifunc,'_Func']);  
INPUT.SmearIm = SmearIm;
INPUT.RoiMask = ROI.roimask;
[ROIMANIP,err] = func(ROIMANIP,INPUT);
if err.flag
    return
end
clear INPUT;

SmearImVals = SmearIm(ROIMANIP.Mask);
OBCALC.sef = mean(SmearImVals);
OBCALC.maxval = max(SmearImVals);

%---------------------------------------------
% ROI Value
%---------------------------------------------
Im = IMAGEANLZ.GetCurrent3DImage;
OBCALC.return(1) = mean(Im(ROIMANIP.Mask));
OBCALC.label{1} = 'ImVal';
OBCALC.ExpDisp = ['(',ROI.roiname,')   ',OBCALC.label{1},':  ',num2str(OBCALC.return(1))];

%---------------------------------------------
% Calculate SEF
%---------------------------------------------
OBCALC.return(2) = OBCALC.sef;
OBCALC.label{2} = 'SEF';
OBCALC.ExpDisp = [OBCALC.ExpDisp,'   ',OBCALC.label{2},':  ',num2str(OBCALC.return(2))];

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
sz = size(ROIMANIP.Mask);
psdmatwid = length(PSD.psd);
psdzf = zeros(sz);
b1 = (sz(1)/2)+1-(psdmatwid-1)/2;
t1 = (sz(1)/2)+1+(psdmatwid-1)/2;
b2 = (sz(2)/2)+1-(psdmatwid-1)/2;
t2 = (sz(2)/2)+1+(psdmatwid-1)/2;
b3 = (sz(3)/2)+1-(psdmatwid-1)/2;
t3 = (sz(3)/2)+1+(psdmatwid-1)/2;
psdzf(b1:t1,b2:t2,b3:t3) = PSD.psd;

%---------------------------------------------
% Calculate CV
%---------------------------------------------
func = str2func([OBCALC.cvcalcfunc,'_Func']);  
INPUT.psd = psdzf;
INPUT.kmatvol = PSD.kmatvol;                          
INPUT.roi = ROIMANIP.Mask;
[CVCALC,err] = func(CVCALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Calculate NEI
%---------------------------------------------
OBCALC.cv = CVCALC.cv;
OBCALC.vinvox = sz(1)*sz(2)*sz(3)/PSD.kmatvol;                         % interp voxels in one real voxel.
OBCALC.mroi = sum(ROIMANIP.Mask(:));
OBCALC.nroi = OBCALC.mroi/OBCALC.vinvox;
OBCALC.volume = OBCALC.nroi*(PROJdgn.vox/10)^3/PROJdgn.elip;          % in cm^3
OBCALC.siv = OBCALC.nroi/OBCALC.cv; 

OBCALC.sdavenoise = OBCALC.sdvnoise/sqrt(OBCALC.siv);
OBCALC.nei95 = 1.96*OBCALC.sdavenoise;

OBCALC.return(3) = OBCALC.nei95;
OBCALC.label{3} = 'NEI95';
OBCALC.ExpDisp = [OBCALC.ExpDisp,'   ',OBCALC.label{3},':  +/-',num2str(OBCALC.return(3))];

OBCALC.saveable = 'No';

Status2('done','',2);
Status2('done','',3);
