%===================================================
%
%===================================================
function ToggleColour(tab,axnum,event)

global IMAGEANLZ
SetFocus(tab,axnum);

%--------------------------------------------
% Change Colour
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).ToggleColour();
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ToggleColour();
    end
% SetFocus(tab,axnum);
end

