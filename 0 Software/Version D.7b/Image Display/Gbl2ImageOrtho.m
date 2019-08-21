%====================================================
% 
%====================================================
function Gbl2ImageOrtho(tab,totgblnum)

global IMAGEANLZ

%----------------------------------------
% Test and Assign Data
%----------------------------------------
axnum = 1;
err = IMAGEANLZ.(tab)(axnum).TestForImage(totgblnum);
if err.flag
    ErrDisp(err)
    return
end
abort = IMAGEANLZ.(tab)(axnum).RoiSizeTest(totgblnum);
if abort == 1
    return
end
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).AssignData(totgblnum);
    IMAGEANLZ.(tab)(axnum).SetAxisActive;
end

%----------------------------------------
% Setup Display
%----------------------------------------
InitializeOrthoPresentation(tab);
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetDataAspectRatio;
end

%----------------------------------------
% Setup MultiDim
%----------------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).MultiDimSetup;
end

%----------------------------------------
% Set Slice 
%----------------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetMiddleSlice;
end

%----------------------------------------
% Set Zoom (if necessary/available)
%----------------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).ResetScale;
end

%----------------------------------------
% Set Dims (if necessary/available)
%----------------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).ResetDims;
    IMAGEANLZ.(tab)(axnum).TestEnableMultiDim;
end

%----------------------------------------
% Load Rois (if necessary/available)
%----------------------------------------
%if IMAGEANLZ.(tab)(axnum).ROITIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax ~= 0 && IMAGEANLZ.(tab)(otherax).SAVEDROISFLAG == 1
%    IMAGEANLZ.(tab)(axnum).CopySavedRois(IMAGEANLZ.(tab)(otherax));
%end

%-----------------------------------
% Contrast
%-----------------------------------
for axnum = 1:3
    if IMAGEANLZ.(tab)(axnum).contrasthold == 0
        IMAGEANLZ.(tab)(axnum).InitializeContrast;
    end
    IMAGEANLZ.(tab)(axnum).SetContrast;
end
    
%-----------------------------------
% Delete 'uicontextmenu' build-up
%-----------------------------------
delete(findobj('Type','uicontextmenu'));
test = findobj;
test = length(test);
% if test > 7200
%     test
%     error;                              % may need to increase if GUI is expanded with more objects
% end

%-----------------------------------
% Plot
%-----------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetImage;
    IMAGEANLZ.(tab)(axnum).SetImageSlice;
    IMAGEANLZ.(tab)(axnum).PlotImage;
    if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
        IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
        IMAGEANLZ.(tab)(1).ComputeAllSavedROIs;
        IMAGEANLZ.(tab)(1).SetSavedROIValues;
    end
    if IMAGEANLZ.(tab)(axnum).GETROIS == 1
        IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
        IMAGEANLZ.(tab)(1).ComputeCurrentROI;
        IMAGEANLZ.(tab)(1).SetCurrentROIValue;
    end
end
DrawOrthoLines(tab);

%-----------------------------------
% Finish up
%-----------------------------------
axnum = 1;
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).Move2Tab;
