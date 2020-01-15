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
for n = 1:3
    %IMAGEANLZ.(tab)(n).ResetScale;
    %IMAGEANLZ.(tab)(n).SetMiddleSlice;
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

