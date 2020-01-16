%===================================================
%
%===================================================
function LoadOverlay(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));
SetFocus(tab,axnum);

%--------------------------------------------
% Load Overlay
%--------------------------------------------
OverlayNumber = str2double(src.Tag(2));
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    Gbl2ImageOverlay(tab,axnum,IMAGEANLZ.(tab)(axnum).totgblnumhl,OverlayNumber);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    Gbl2ImageOrthoOverlay(tab,IMAGEANLZ.(tab)(1).totgblnumhl,OverlayNumber);
end

