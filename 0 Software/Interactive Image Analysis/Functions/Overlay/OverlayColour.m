%===================================================
%
%===================================================
function OverlayColour(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));
SetFocus(tab,axnum);

if src.Value == 2
    usecolour = 'Yes';
else
    usecolour = 'No';
end

%--------------------------------------------
% Change Colour
%--------------------------------------------
overlaynum = str2double(src.Tag(2));
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ToggleOverlayColour(overlaynum,usecolour);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ToggleOverlayColour(overlaynum,usecolour);
    end
end

