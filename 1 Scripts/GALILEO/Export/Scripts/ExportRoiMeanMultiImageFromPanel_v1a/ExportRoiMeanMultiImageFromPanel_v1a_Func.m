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
% Get Data
%---------------------------------------------
for n = 1:length(totgblnums)    
    err = IMAGEANLZ.TestForImage(totgblnums(n));
    if err.flag
        continue
    end
    IMAGEANLZ.AssignData(totgblnums(n));
    for m = 1:length(ROIS)
        ROIS(m).ComputeROI(IMAGEANLZ);
        RoiMean(m,n) = ROIS(m).roimean;
        RoiNames{m} = ROIS(m).roiname;
    end
    imagenames = IMAGEANLZ.GetImageName;
    ImageNames{n} = strtok(imagenames,'.');
end

%---------------------------------------------
% Export Table
%---------------------------------------------
T = array2table(RoiMean,'RowNames',RoiNames,'VariableName',ImageNames)
global SCRPTPATHS
roisloc = SCRPTPATHS.(tab)(1).roisloc;
writetable(T,[roisloc,'TempExcel.xlsx'],'WriteRowNames',true);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
