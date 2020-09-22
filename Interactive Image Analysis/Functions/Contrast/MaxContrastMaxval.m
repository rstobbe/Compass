%===================================================
% 
%===================================================
function MaxContrastMaxval(src,event)

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

maxcmax = str2double(src.String);
if IMAGEANLZ.(tab)(axnum).TestMaxCMaxValUserEditTooSmall(maxcmax)
    return
end

IMAGEANLZ.(tab)(axnum).MaxCMaxValUserEdit;
cmax = IMAGEANLZ.(tab)(axnum).ReduceCMaxValTest(src.String);
cmin = IMAGEANLZ.(tab)(axnum).ReduceCMinValTest(src.String);

if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).MaxContrastMaxUpdate(maxcmax); 
    IMAGEANLZ.(tab)(axnum).ChangeMaxContrastVal(cmax);
    IMAGEANLZ.(tab)(axnum).ChangeMinContrastVal(cmin);
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider; 
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider;  
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).MaxContrastMaxUpdate(maxcmax);
        IMAGEANLZ.(tab)(n).ChangeMaxContrastVal(cmax);
        IMAGEANLZ.(tab)(n).ChangeMinContrastVal(cmin);
    end
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider;
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider;  
end


