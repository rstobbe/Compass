%===================================================
% 
%===================================================
function OverlayMaxEdit(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));
SetFocus(tab,axnum);

%--------------------------------------------
% Set Colour
%--------------------------------------------
overlaynum = str2double(src.Tag(2));
IMAGEANLZ.(tab)(axnum).FIGOBJS.OverlayMax(overlaynum).ForegroundColor = [0.8 0.5 0.3];