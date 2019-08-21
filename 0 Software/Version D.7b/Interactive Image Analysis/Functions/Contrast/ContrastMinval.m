%===================================================
% 
%===================================================
function ContrastMinval(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
if isempty(tab)
    tab = src.Parent.Parent.Parent.Parent.Parent.Tag;
end
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if isnan(str2double(src.String))
    return
end
val = str2double(src.String)/IMAGEANLZ.(tab)(axnum).MAXCONTRAST;
IMAGEANLZ.(tab)(axnum).ChangeMinContrast(val);








