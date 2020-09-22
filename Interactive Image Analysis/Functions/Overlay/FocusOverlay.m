%===================================================
%
%===================================================
function FocusOverlay(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));
SetFocus(tab,axnum);

%--------------------------------------------
% Change Colour
%--------------------------------------------
overlaynum = str2double(src.Tag(2));
for m = 1:4
    if m == overlaynum
        val = 0.3;
    else
        val = 0;
    end
    if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
        IMAGEANLZ.(tab)(axnum).SetOverlayTransparency(m,val);
        IMAGEANLZ.(tab)(axnum).SetOverlaySlider(m,val);
    elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
        for n = 1:3
            IMAGEANLZ.(tab)(n).SetOverlayTransparency(m,val);
            IMAGEANLZ.(tab)(n).SetOverlaySlider(m,val);
        end
    end
end
