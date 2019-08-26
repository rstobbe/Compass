%=========================================================
% 
%=========================================================

function [MOF,err] = ShimFiguresNoMask_v1a_Func(MOF,INPUT)

Status2('busy','Plot Shimming Figures',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT

%----------------------------------------------
% Test Image Size
%----------------------------------------------
BaseIm = squeeze(Image(:,:,:,1));
fMap = squeeze(Image(:,:,:,2));
%Mask = squeeze(Image(:,:,:,3));
Prof = squeeze(Image(:,:,:,4));
plotshim = 0;
if sum(Prof(:)) ~= 0
    plotshim = 1;
end

%----------------------------------------------
% Base Image
%----------------------------------------------
dispwid1 = [0 0.9*max(abs(BaseIm(:)))];
MSTRCT.dispwid1 = dispwid1;

%----------------------------------------------
% Image Aspects
%----------------------------------------------
MSTRCT.intensity = 'Flat50';
MSTRCT.type1 = 'abs';
MSTRCT.type2 = 'real';

%----------------------------------------------
% Plot Original Full Image
%----------------------------------------------
MSTRCT.figno = '1000';
if strcmp(MOF.dispwid,'Full')
    dispwid(1) = -max(abs(fMap(:)));
    dispwid(2) = -dispwid(1);
    MSTRCT.dispwid2 = dispwid;
else
    ind = strfind(MOF.dispwid,',');
    MSTRCT.dispwid2(1) = str2double(MOF.dispwid(1:ind-1));
    MSTRCT.dispwid2(2) = str2double(MOF.dispwid(ind+1:end));
    dispwid(1) = MSTRCT.dispwid2(1);
    dispwid(2) = MSTRCT.dispwid2(2);
end
INPUT.MSTRCT = MSTRCT;
INPUT.Image(:,:,:,1) = BaseIm;
INPUT.Image(:,:,:,2) = fMap;
[~,err] = PlotMontageOverlay_v1c(INPUT);
title('Original B0 Map');

%---------------------------------------------
% Plot Original Full Histogram
%---------------------------------------------
test = fMap(:);
test(test<dispwid(1)) = NaN;
test(test>dispwid(2)) = NaN;
test = test(not(isnan(test)));
figure(2000); hold on;
cens = (dispwid(1):MOF.histstep:dispwid(2));
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,'r');
xlabel('Off Resonance (Hz)'); ylabel('Voxels');
title('Histogram');
set(gca,'XDir','reverse');

if plotshim == 0
    return
end

%----------------------------------------------
% Plot Fitted Full Image
%----------------------------------------------
MSTRCT.figno = '1001';
MSTRCT.dispwid2(1) = dispwid(1);
MSTRCT.dispwid2(2) = dispwid(2);
INPUT.MSTRCT = MSTRCT;
INPUT.Image(:,:,:,1) = BaseIm;
INPUT.Image(:,:,:,2) = fMap-Prof;
[~,err] = PlotMontageOverlay_v1c(INPUT);
title('Projected B0 Map');

%---------------------------------------------
% Plot Fitted Full Histogram
%---------------------------------------------
test = fMap(:)-Prof(:);
test(test<dispwid(1)) = NaN;
test(test>dispwid(2)) = NaN;
test = test(not(isnan(test)));
figure(2000); hold on;
cens = (dispwid(1):MOF.histstep:dispwid(2));
[nels,cens] = hist(test,cens);
nels = smooth(nels,5,'moving');
plot(cens,nels,'k');
set(gca,'XDir','reverse');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',3);

