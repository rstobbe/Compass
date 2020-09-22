%====================================================
% 
%====================================================
function Gbl2ImageOverlay(tab,axnum,totgblnum,overlaynum)

global IMAGEANLZ

%----------------------------------------
% Test and Assign Data
%----------------------------------------
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

IMAGEANLZ.(tab)(axnum).AssignOverlay(totgblnum,overlaynum);
IMAGEANLZ.(tab)(axnum).SetOverlayName(overlaynum);

%----------------------------------------
% Test Colour Image
%----------------------------------------
[colourimage,dim4] = IMAGEANLZ.(tab)(axnum).TestColourOverlay(overlaynum);
if dim4~=1
    IMAGEANLZ.(tab)(axnum).SetOverlayDimension(dim4);
elseif colourimage == 1
    IMAGEANLZ.(tab)(axnum).SetColourOverlay(overlaynum);
end

%-----------------------------------
% Contrast
%-----------------------------------
IMAGEANLZ.(tab)(axnum).OverlaySaveContrast(overlaynum);
if IMAGEANLZ.(tab)(axnum).contrasthold == 0
    ContrastSettings = IMAGEANLZ.(tab)(axnum).OverlayInitializeContrast(overlaynum);          
    IMAGEANLZ.(tab)(axnum).OverlayInitializeContrastSpecify(ContrastSettings,overlaynum); 
end
IMAGEANLZ.(tab)(axnum).OverlayLoadContrast(overlaynum);

%-----------------------------------
% Plot
%-----------------------------------
IMAGEANLZ.(tab)(axnum).SetOverlay(overlaynum);
IMAGEANLZ.(tab)(axnum).SetOverlaySlice(overlaynum);
IMAGEANLZ.(tab)(axnum).PlotImage;
if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
end
if IMAGEANLZ.(tab)(axnum).GETROIS == 1
    IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
end

%-----------------------------------
% Finish up
%-----------------------------------
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).Move2Tab;
