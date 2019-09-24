%===================================================
%
%===================================================
function OverlayColour(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

if src.Value == 2
    usecolour = 'Yes';
else
    usecolour = 'No';
end

%--------------------------------------------
% Change Colour
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ToggleOverlayColour(usecolour);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ToggleOverlayColour(usecolour);
    end
end

