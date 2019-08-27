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

if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
    error;          % shouldn't get here
end

%------------------------------------------
% Set Orientation
%------------------------------------------
IMAGEANLZ.(tab)(axnum).SetOrient(src.String{src.Value});
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    InitializeOrthoPresentation(tab)
end

%----------------------------------------
% Tieing Let-go
%----------------------------------------
untie = 0;
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if not(strcmp(IMAGEANLZ.(tab)(r).ORIENT,IMAGEANLZ.(tab)(axnum).ORIENT))
        untie = 1;
        break
    end
end
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if untie == 1
        IMAGEANLZ.(tab)(r).TieSlice(0);
        IMAGEANLZ.(tab)(r).TieZoom(0);
        IMAGEANLZ.(tab)(r).TieDatVals(0);
        IMAGEANLZ.(tab)(r).TieCursor(0);
    end
end

%----------------------------------------
% Plot
%----------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    arr = 1:3;
else
    arr = axnum;
end
for n = arr
    IMAGEANLZ.(tab)(n).ResetScale;
    IMAGEANLZ.(tab)(n).SetMiddleSlice;
    IMAGEANLZ.(tab)(n).SetImage;
    IMAGEANLZ.(tab)(n).SetImageSlice;
    IMAGEANLZ.(tab)(n).PlotImage;
    IMAGEANLZ.(tab)(n).SetDataAspectRatio;
    IMAGEANLZ.(tab)(n).DrawSavedROIs([]);
    IMAGEANLZ.(tab)(n).DrawCurrentROI([]);
end

if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end

