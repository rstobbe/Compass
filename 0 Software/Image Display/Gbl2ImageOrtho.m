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
samedims = IMAGEANLZ.(tab)(axnum).ImageDimsCompare(totgblnum);
if samedims == 0
    abort = IMAGEANLZ.(tab)(axnum).RoiSizeTest(totgblnum);
    if abort == 1
        return
    end
end
ImType = IMAGEANLZ.(tab)(axnum).GetImType;
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).ResetImTypeSpecify(ImType);
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
if samedims == 0
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).SetMiddleSlice;
    end
end

%----------------------------------------
% Set Zoom (if necessary/available)
%----------------------------------------
if samedims == 0
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ResetScale;
    end
end

%----------------------------------------
% Set Dims (if necessary/available)
%----------------------------------------
axnum = 1;
colourimage = IMAGEANLZ.(tab)(axnum).TestColourImage;
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).ResetDims;
    IMAGEANLZ.(tab)(axnum).TestEnableMultiDim(colourimage);
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
    IMAGEANLZ.(tab)(axnum).SaveContrast;
end
if IMAGEANLZ.(tab)(1).contrasthold == 0
    ContrastSettings = IMAGEANLZ.(tab)(1).InitializeContrast;          
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).InitializeContrastSpecify(ContrastSettings); 
    end
end
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).LoadContrast
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
        if axnum == 1
            IMAGEANLZ.(tab)(1).ComputeAllSavedROIs;
            IMAGEANLZ.(tab)(1).SetSavedROIValues;
        end
    end
    if IMAGEANLZ.(tab)(axnum).GETROIS == 1
        IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
        if axnum == 1
            IMAGEANLZ.(tab)(1).ComputeCurrentROI;
            IMAGEANLZ.(tab)(1).SetCurrentROIValue;
        end
    end
end
DrawOrthoLines(tab);

%-----------------------------------
% Lines
%-----------------------------------
if samedims == 1
    for axnum = 1:3
        if IMAGEANLZ.(tab)(axnum).TestSavedLines
            IMAGEANLZ.(tab)(axnum).DrawSavedLines;
        end
    end
else
    for linenum = 1:3
        for r = 1:3
            GlobalSavedLinesInd = IMAGEANLZ.(tab)(r).DeleteSavedLine(linenum);
            IMAGEANLZ.(tab)(r).UpdateGlobalSavedLinesInd(GlobalSavedLinesInd); 
        end
        IMAGEANLZ.(tab)(1).DeleteSavedLineData(linenum); 
    end
end

%-----------------------------------
% Finish up
%-----------------------------------
axnum = 1;
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).Move2Tab;
