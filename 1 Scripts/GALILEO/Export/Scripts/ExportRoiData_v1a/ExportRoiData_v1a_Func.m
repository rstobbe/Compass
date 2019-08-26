%=========================================================
% 
%=========================================================

function [ROIANLZ,err] = ExportRoiData_v1a_Func(ROIANLZ,INPUT)

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
totgblnums = INPUT.totgblnums;
tab = INPUT.tab;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if length(totgblnums) > 1
    err.flag = 1;
    err.msg = 'Selection of only 1 image supported';
    return
end

%---------------------------------------------
% Get Data
%---------------------------------------------  
err = IMAGEANLZ.TestForImage(totgblnums);
if err.flag
    err.msg = 'Image error';
    return
end
IMAGEANLZ.AssignData(totgblnums);
for m = 1:length(ROIS)
    ROIS(m).ComputeROI(IMAGEANLZ);
    RoiData(m,1) = ROIS(m).roimean;
    RoiData(m,2) = ROIS(m).roisdv;
    RoiData(m,3) = ROIS(m).roivol;
    RoiNames{m} = ROIS(m).roiname;
end
imagename = IMAGEANLZ.GetImageName;
ImageName = strtok(imagename,'.');

%---------------------------------------------
% Export Table
%---------------------------------------------
T = array2table(RoiData,'RowNames',RoiNames,'VariableName',{'Mean','Stdev','Vol'})
global SCRPTPATHS
roisloc = SCRPTPATHS.(tab)(1).roisloc;
writetable(T,[roisloc,'\',ImageName,'_RoiData.xlsx'],'WriteRowNames',true);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
