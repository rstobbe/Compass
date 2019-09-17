%===================================================
% 
%===================================================
function MaxContrastMaxEdit(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Set Colour
%--------------------------------------------
IMAGEANLZ.(tab)(axnum).FIGOBJS.MaxCMaxVal.ForegroundColor = [0.8 0.5 0.3];