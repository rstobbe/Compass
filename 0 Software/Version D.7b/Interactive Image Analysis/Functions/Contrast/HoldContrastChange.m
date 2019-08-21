%===================================================
% 
%===================================================
function HoldContrastChange(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if not(IMAGEANLZ.(tab)(axnum).TestAxisActive);
    return
end

if not(isempty(IMAGEANLZ.(tab)(axnum).buttonfunction))
    error;          % shouldn't get here
end

%--------------------------------------------
% Toggle Contrast Hold
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ToggleContrast(src.Value); 
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for r = 1:3
        IMAGEANLZ.(tab)(r).ToggleContrast(src.Value); 
    end
end