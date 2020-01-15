%=========================================================
% 
%=========================================================

function [NPICALC,err] = CalcNEI_v1a_Func(NPICALC,INPUT)

Status2('busy','Calculate NPI',2);
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
clear INPUT

%---------------------------------------------
% ZeroFill PSD
%---------------------------------------------
sz = size(ROI.roimask);
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
func = str2func([NPICALC.cvcalcfunc,'_Func']);  
INPUT.psd = psdzf;
INPUT.kmatvol = PSD.kmatvol;                          
INPUT.roi = ROI.roimask;
[CVCALC,err] = func(CVCALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Calculate NPI
%---------------------------------------------
NPICALC.cv = CVCALC.cv;
NPICALC.vinvox = sz(1)*sz(2)*sz(3)/PSD.kmatvol;                         % interp voxels in one real voxel.
NPICALC.mroi = sum(ROI.roimask(:));
NPICALC.nroi = NPICALC.mroi/NPICALC.vinvox;
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
