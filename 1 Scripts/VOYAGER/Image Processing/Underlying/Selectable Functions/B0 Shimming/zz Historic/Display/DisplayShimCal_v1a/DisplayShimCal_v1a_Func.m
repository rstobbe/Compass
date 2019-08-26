%===========================================
% 
%===========================================

function [DISP,err] = DisplayShimCal_v1a_Func(DISP,INPUT)

Status2('busy','Display Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
wid = INPUT.wid;
fMap = INPUT.fMap;
PLOT = DISP.PLOT;
clear INPUT;

%---------------------------------------------
% Base Image
%---------------------------------------------
BaseIm = abs((Im(:,:,:,1)+Im(:,:,:,2))/2);
MagMask = ones(size(BaseIm));
MagMask(BaseIm < 0.05*max(BaseIm(:))) = NaN;
BaseIm = BaseIm.*MagMask;

%---------------------------------------------
% Plotting Image
%---------------------------------------------
Image = cat(4,BaseIm,fMap);
MSTRCT.start = 1;
MSTRCT.stop = length(BaseIm);
MSTRCT.step = 1;
MSTRCT.ncolumns = 8;
MSTRCT.imsize = '800,700';
MSTRCT.figno = 'Continue';
MSTRCT.slclbl = 'Yes';
MSTRCT.dispwid1 = [0 1];
MSTRCT.type1 = 'abs';
MSTRCT.dispwid2 = [-wid wid];             
MSTRCT.type2 = 'real';

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
INPUT.intensity = 'Flat100';
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Histogram (full)
%---------------------------------------------
test = fMap(:);
test = test(not(isnan(test)));
figure(2000); hold on;
[nels,cens] = hist(test,1000);
nels = smooth(nels,5,'moving');
plot(cens,nels,'b');
xlabel('Resonance (Hz)'); ylabel('Voxels');
title('Resonance Histogram');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);