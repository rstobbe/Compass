%====================================================
% 
%====================================================
function Gbl2ImageOrthoOverlay(tab,totgblnum,overlaynum)

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
if ~IMAGEANLZ.(tab)(axnum).TestForLoadedImage
    err.flag = 1;
    err.msg = 'No base image loaded';
    ErrDisp(err);
    return
end
samedims = IMAGEANLZ.(tab)(axnum).ImageDimsCompare(totgblnum);
if samedims == 0
    err.flag = 1;
    err.msg = 'Overlay different dimensions than image';
    ErrDisp(err);
    return
end

for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).AssignOverlay(totgblnum,overlaynum);
end

IMAGEANLZ.(tab)(1).SetOverlayName(overlaynum);

%----------------------------------------
% Test Colour Image
%----------------------------------------
[colourimage,dim4] = IMAGEANLZ.(tab)(1).TestColourOverlay(overlaynum);
if dim4 == 0 
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).DeleteOverlay(overlaynum);
    end
    return
end
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetOverlayDimension(overlaynum,dim4);
end
if colourimage == 1
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).SetColourOverlay(overlaynum);
    end
end
   
%-----------------------------------
% Contrast
%-----------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).OverlaySaveContrast(overlaynum);
end
if IMAGEANLZ.(tab)(1).contrasthold == 0
    ContrastSettings = IMAGEANLZ.(tab)(1).OverlayInitializeContrast(overlaynum);          
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).OverlayInitializeContrastSpecify(ContrastSettings,overlaynum); 
    end
end
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).OverlayLoadContrast(overlaynum);
end

%-----------------------------------
% Plot
%-----------------------------------
for axnum = 1:3
    IMAGEANLZ.(tab)(axnum).SetOverlay(overlaynum);
    IMAGEANLZ.(tab)(axnum).SetOverlaySlice(overlaynum);
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
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).Move2Tab;
