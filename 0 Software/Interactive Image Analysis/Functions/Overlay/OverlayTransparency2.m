%===================================================
% 
%===================================================
function OverlayTransparency2(src,event)

global IMAGEANLZ

tab = event.AffectedObject.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = event.AffectedObject.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(event.AffectedObject.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).SetOverLayTransparency(event.AffectedObject.Value);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).SetOverLayTransparency(event.AffectedObject.Value);
    end
end

