%=========================================================
% 
%=========================================================

function [ROIANLZ,err] = ExportRoiMeanMultiDim_v1a_Func(ROIANLZ,INPUT)

Status('busy','Export ROI Data');
Status2('done','',2);
Status2('done','',3);

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
% Get Data
%---------------------------------------------  
imsize = IMAGEANLZ.GetBaseImageSize([]);
for n = 1:imsize(4)
    IMAGEANLZ.SetDim4(n);
    for m = 1:length(ROIS)
        ROIS(m).ComputeROI(IMAGEANLZ);
        RoiData(m,n) = ROIS(m).roimean;
        RoiNames{m} = ROIS(m).roiname;
    end
end
imagename = IMAGEANLZ.GetImageName;
ImageName = strtok(imagename,'.');

%---------------------------------------------
% Export Table
%---------------------------------------------
T = array2table(RoiData)
global SCRPTPATHS
roisloc = SCRPTPATHS.(tab)(1).roisloc;
writetable(T,[roisloc,'\',ImageName,'_RoiData.xlsx'],'WriteRowNames',true);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
