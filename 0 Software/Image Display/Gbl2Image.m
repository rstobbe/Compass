%====================================================
% 
%====================================================
function Gbl2Image(tab,axnum,totgblnum)

Status('busy','Load Image');
Status2('done','',2);
Status2('done','',3);

global IMAGEANLZ
global FIGOBJS

%----------------------------------------
% Test and Assign Data
%----------------------------------------
err = IMAGEANLZ.(tab)(axnum).TestForImage(totgblnum);
if err.flag
    ErrDisp(err)
    return
end
abort = IMAGEANLZ.(tab)(axnum).RoiSizeTest(totgblnum);
if abort == 1
    Status('done','');
    return
end
IMAGEANLZ.(tab)(axnum).HoldingTest(totgblnum);
IMAGEANLZ.(tab)(axnum).AssignData(totgblnum);
IMAGEANLZ.(tab)(axnum).Move2Tab;

%----------------------------------------
% Remove Script Figure (if any)
%----------------------------------------
if isfield(FIGOBJS.(tab),'DispPan')
    if axnum <= length(FIGOBJS.(tab).DispPan)
        delete(FIGOBJS.(tab).DispPan(axnum))
    end
end

%----------------------------------------
% Setup Display
%----------------------------------------
IMAGEANLZ.(tab)(axnum).SetDataAspectRatio;

%----------------------------------------
% Setup MultiDim
%----------------------------------------
IMAGEANLZ.(tab)(axnum).MultiDimSetup;

%----------------------------------------
% Tieing Tests
%----------------------------------------
reset = zeros(1,IMAGEANLZ.(tab)(axnum).axeslen);
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if axnum ~= r
        if not(IMAGEANLZ.(tab)(r).TestAxisActive)
            continue
        end
        othersize = IMAGEANLZ.(tab)(r).GetBaseImageSize([]);
        reset(r) = IMAGEANLZ.(tab)(axnum).TieTest(othersize);
    end
end 
reset = max(reset);
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if reset == 2
        IMAGEANLZ.(tab)(r).UnTieAll;
    elseif reset == 1
        IMAGEANLZ.(tab)(r).TieDims(0);
    end
end

%----------------------------------------
% Search for a Non-Empty Axes
%----------------------------------------
otherax = 0;
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if r ~= axnum
        if IMAGEANLZ.(tab)(r).TestAxisActive;
            otherax = r;
            break
        end
    end
end 

%----------------------------------------
% Set Slice (if necessary/available)
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).SLCTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax ~= 0
    IMAGEANLZ.(tab)(axnum).CopySlice(IMAGEANLZ.(tab)(otherax));
elseif (IMAGEANLZ.(tab)(axnum).SLCTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax == 0) || IMAGEANLZ.(tab)(axnum).SLCHOLD == 0
    IMAGEANLZ.(tab)(axnum).SetMiddleSlice;
end

%----------------------------------------
% Set Zoom (if necessary/available)
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).ZOOMTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax ~= 0
    IMAGEANLZ.(tab)(axnum).CopyScale(IMAGEANLZ.(tab)(otherax));
elseif (IMAGEANLZ.(tab)(axnum).ZOOMTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax == 0) || IMAGEANLZ.(tab)(axnum).ZOOMHOLD == 0
    IMAGEANLZ.(tab)(axnum).ResetScale;
end

%----------------------------------------
% Set Dims (if necessary/available)
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).DIMSTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax ~= 0
    IMAGEANLZ.(tab)(axnum).CopyDims(IMAGEANLZ.(tab)(otherax));
elseif (IMAGEANLZ.(tab)(axnum).DIMSTIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax == 0) || IMAGEANLZ.(tab)(axnum).DIMSHOLD == 0
    IMAGEANLZ.(tab)(axnum).ResetDims;
end
IMAGEANLZ.(tab)(axnum).TestEnableMultiDim;

%----------------------------------------
% Load Rois (if necessary/available)
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).ROITIE == 1 && not(IMAGEANLZ.(tab)(axnum).TestAxisActive) && otherax ~= 0 && IMAGEANLZ.(tab)(otherax).SAVEDROISFLAG == 1
    IMAGEANLZ.(tab)(axnum).CopySavedRois(IMAGEANLZ.(tab)(otherax));
end

%-----------------------------------
% Contrast
%-----------------------------------
if IMAGEANLZ.(tab)(axnum).contrasthold == 0
    IMAGEANLZ.(tab)(axnum).InitializeContrast;
end
IMAGEANLZ.(tab)(axnum).SetContrast;

%-----------------------------------
% Delete 'uicontextmenu' build-up
%-----------------------------------
delete(findobj('Type','uicontextmenu'));
test = findobj;
test = length(test);
if test > 10000
    test
    error;                              % may need to increase if GUI is expanded with more objects
end

%-----------------------------------
% Plot
%-----------------------------------
IMAGEANLZ.(tab)(axnum).SetImage;
IMAGEANLZ.(tab)(axnum).SetImageSlice;
IMAGEANLZ.(tab)(axnum).PlotImage;
if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
    IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
    IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
end
if IMAGEANLZ.(tab)(axnum).GETROIS == 1
    IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
    IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
    IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
end

%-----------------------------------
% Finish up
%-----------------------------------
IMAGEANLZ.(tab)(axnum).ShowImageInfo;
IMAGEANLZ.(tab)(axnum).UnHighlight;
IMAGEANLZ.(tab)(axnum).TurnOnDisplay;
IMAGEANLZ.(tab)(axnum).SetImageName;
IMAGEANLZ.(tab)(axnum).SetAxisActive;

% if strcmp(tab,'IM')
%     IMAGEANLZ.(tab)(axnum).FIGOBJS.UberTabGroup.SelectedTab = IMAGEANLZ.(tab)(axnum).FIGOBJS.TopGeneralTab;
% elseif strcmp(tab,'IM2') || strcmp(tab,'IM3')
%     IMAGEANLZ.(tab)(axnum).FIGOBJS.UberTabGroup.SelectedTab = IMAGEANLZ.(tab)(axnum).FIGOBJS.TopAnlzTab;
% end


Status('done','');
Status2('done','',2);
Status2('done','',3);
