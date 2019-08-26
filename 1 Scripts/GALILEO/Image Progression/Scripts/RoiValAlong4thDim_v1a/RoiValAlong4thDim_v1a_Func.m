%=========================================================
% 
%=========================================================

function [ROIANLZ,err] = RoiValAlong4thDim_v1a_Func(ROIANLZ,INPUT)

Status('busy','ROI Values Along 4th-Dim');
Status2('done','',2);
Status2('done','',3);

global SCRPTPATHS

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROIS = INPUT.ROIS;
IMAGEANLZ = INPUT.IMAGEANLZ;
tab = INPUT.tab;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if length(ROIS) > 1
    err.flag = 1;
    err.msg = 'Only 1 Active ROI at a time';
    return
end

%---------------------------------------------
% Calculate ROI Parameters
%---------------------------------------------
imsize = IMAGEANLZ.GetBaseImageSize([]);
Dim4Size = imsize(4);

ROIANLZ.ExpDisp = char(13);
for n = 1:Dim4Size
    IMAGEANLZ.SetDim4(n);
    ROIS.ComputeROI(IMAGEANLZ);
    meanval(n) = ROIS.roimean;
    ROIANLZ.ExpDisp = [ROIANLZ.ExpDisp,num2str(meanval(n)),char(13)];
end

%---------------------------------------------
% Plot Output
%---------------------------------------------
figure(160198); hold on;
B0nums = (1:11:Dim4Size);
plot(meanval);
plot(B0nums,meanval(B0nums),'r*');
%ylim([0 100*ceil(meanval(1)/100)]);
title('Mean ROI Value Along 4th Dimension');
xlabel('4th Dimension Value');
ylabel('Arbitrary Mean ROI Value');
ylim([0 800]);

roisloc = SCRPTPATHS.(tab)(1).roisloc;
T = table(meanval);
writetable(T,[IMAGEANLZ.IMPATH,ROIS.roiname,'_MeanArray.xlsx']);

ROIANLZ.saveable = 'Yes';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
