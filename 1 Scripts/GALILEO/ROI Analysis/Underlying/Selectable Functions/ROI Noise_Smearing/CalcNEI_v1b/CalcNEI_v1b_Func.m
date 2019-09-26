%=========================================================
% 
%=========================================================

function [NPICALC,err] = CalcNEI_v1b_Func(NPICALC,INPUT)

Status2('busy','Calculate Noise Error Interval',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CVCALC = NPICALC.CVCALC;
PSD = NPICALC.PSD;
PROJdgn = PSD.PROJdgn;
ROI = INPUT.ROI;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% Image Info
%---------------------------------------------
pixdim = IMAGEANLZ.GetPixelDimensions;
zf = (PROJdgn.fov./pixdim);

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
psdmatwid = length(PSD.psd);
psdzf = zeros(zf);
if round(rem(psdmatwid,2)*1e6) == 0
    b1 = (zf(1)-psdmatwid)/2+1;
    t1 = b1+psdmatwid-1;
    b2 = (zf(2)-psdmatwid)/2+1;
    t2 = b1+psdmatwid-1;  
    b3 = (zf(3)-psdmatwid)/2+1;
    t3 = b1+psdmatwid-1;  
else
    b1 = (zf(1)/2)+1-(psdmatwid-1)/2;
    t1 = (zf(1)/2)+1+(psdmatwid-1)/2;
    b2 = (zf(2)/2)+1-(psdmatwid-1)/2;
    t2 = (zf(2)/2)+1+(psdmatwid-1)/2;
    b3 = (zf(3)/2)+1-(psdmatwid-1)/2;
    t3 = (zf(3)/2)+1+(psdmatwid-1)/2;
end
psdzf(b1:t1,b2:t2,b3:t3) = PSD.psd;
%--
figure(1000); hold on;
plot(squeeze(psdzf(:,zf(2)/2+1,zf(3)/2+1)),'b');
plot(squeeze(psdzf(zf(2)/2+1,:,zf(3)/2+1)),'g');
plot(squeeze(psdzf(zf(2)/2+1,zf(3)/2+1,:)),'r');

%---------------------------------------------
% Restore Image FoV (if needed)
%---------------------------------------------
sz = size(ROI.roimask);
bot = (zf-sz)/2+1;
top = bot+sz-1;
roimask = zeros(zf);
roimask(bot(1):top(1),bot(2):top(2),bot(3):top(3)) = ROI.roimask;

%---------------------------------------------
% Calculate CV
%---------------------------------------------
func = str2func([NPICALC.cvcalcfunc,'_Func']);  
INPUT.psd = psdzf;
INPUT.kmatvol = PSD.kmatvol;                          
INPUT.roi = roimask;
[CVCALC,err] = func(CVCALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Calculate NPI
%---------------------------------------------
NPICALC.cv = CVCALC.cv;
NPICALC.vinvox = zf(1)*zf(2)*zf(3)/PSD.kmatvol;                         % interp voxels in one real voxel.
NPICALC.mroi = sum(roimask(:));
NPICALC.nroi = NPICALC.mroi/NPICALC.vinvox
NPICALC.volume = NPICALC.nroi*(PROJdgn.vox/10)^3/PROJdgn.elip;          % in cm^3
NPICALC.siv = NPICALC.nroi/NPICALC.cv; 

NPICALC.sdavenoise = NPICALC.sdvnoise/sqrt(NPICALC.siv);
NPICALC.npi95 = 1.96*NPICALC.sdavenoise;

NPICALC.return = NPICALC.npi95;
NPICALC.label = {'NEI95'};
NPICALC.ExpDisp = ['(',ROI.roiname,')   ',NPICALC.label{1},':  +/-',num2str(NPICALC.npi95)];

NPICALC.saveable = 'yes';

Status2('done','',2);
Status2('done','',3);
