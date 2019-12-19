%====================================================
% 
%====================================================
function Gbl2ImageOrthoOverlay(tab,totgblnum)

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

for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).AssignOverlay(totgblnum);
end

%-----------------------------------
% Contrast
%-----------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).OverlaySaveContrast;
end
if IMAGEANLZ.(tab)(1).contrasthold == 0
    ContrastSettings = IMAGEANLZ.(tab)(axnum).OverlayInitializeContrast;          
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).OverlayInitializeContrastSpecify(ContrastSettings); 
    end
end
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).OverlayLoadContrast;
end

%-----------------------------------
% Plot
%-----------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetImage;
    IMAGEANLZ.(tab)(axnum).SetImageSlice;
    IMAGEANLZ.(tab)(axnum).PlotImage;
    if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
        IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
    end
    if IMAGEANLZ.(tab)(axnum).GETROIS == 1
        IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
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
