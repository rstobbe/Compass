%===================================================
% 
%===================================================
function OverlayTransparency(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));

%--------------------------------------------
% 
%--------------------------------------------
overlaynum = str2double(src.Tag(2));
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).SetOverLayTransparency(overlaynum,src.Value);  
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).SetOverLayTransparency(overlaynum,src.Value);  
    end
end


