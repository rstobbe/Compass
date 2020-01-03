%===================================================
% 
%===================================================
function OverlayMinval(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag(1));

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if isnan(str2double(src.String))
    return
end
SetFocus(tab,axnum);

overlaynum = str2double(src.Tag(2));
IMAGEANLZ.(tab)(axnum).OverlayMinUserEdit(overlaynum);
 
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).ChangeMinOverlayVal(overlaynum,str2double(src.String));
    end
end


