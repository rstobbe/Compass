%===================================================
% 
%===================================================
function OverlayMaxval(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if isnan(str2double(src.String))
    return
end
SetFocus(tab,axnum);

IMAGEANLZ.(tab)(axnum).OverlayMaxUserEdit;
 
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).ChangeMaxOverlayVal(str2double(src.String));
    end
end


