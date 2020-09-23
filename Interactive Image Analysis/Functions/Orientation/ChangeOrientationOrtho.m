%===================================================
%
%===================================================
function ChangeOrientationOrtho(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if not(IMAGEANLZ.(tab)(axnum).TestAxisActive)
    return
end

% if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
%     error;          % shouldn't get here
% end

if not(strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho'))
    error;              % shouldn't get here
end

%------------------------------------------
% Set Orientation
%------------------------------------------
Orient = IMAGEANLZ.(tab)(axnum).GetOrient;
IMAGEANLZ.(tab)(axnum).SetOrient(src.String{src.Value},src.Value);
UpdateOrthoOrientations(tab,Orient);

%----------------------------------------
% Plot
%----------------------------------------
samedims = 0;
sz = IMAGEANLZ.(tab)(1).GetImageSize;
if sz(1) == sz(2) && sz(1) == sz(3)
    samedims = 1;
end
for n = 1:3
    if samedims == 0
        IMAGEANLZ.(tab)(n).ResetScale;                      % hack for now
    end
    IMAGEANLZ.(tab)(n).SetImage;
    if IMAGEANLZ.(tab)(n).TestForAnyOverlay
        IMAGEANLZ.(tab)(n).SetActiveOverlays;
    end
    IMAGEANLZ.(tab)(n).SetImageSlice;
    IMAGEANLZ.(tab)(n).PlotImage;
    IMAGEANLZ.(tab)(n).SetDataAspectRatio;
    IMAGEANLZ.(tab)(n).DrawSavedROIs([]);
    IMAGEANLZ.(tab)(n).DrawCurrentROI([]);
end

if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end

