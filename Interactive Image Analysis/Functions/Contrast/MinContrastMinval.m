%===================================================
% 
%===================================================
function MinContrastMinval(src,event)

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

mincmin = str2double(src.String);
if IMAGEANLZ.(tab)(axnum).TestMinCMinValUserEditTooBig(mincmin)
    return
end

IMAGEANLZ.(tab)(axnum).MinCMinValUserEdit;
cmin = IMAGEANLZ.(tab)(axnum).IncreaseCMinValTest(src.String);
cmax = IMAGEANLZ.(tab)(axnum).IncreaseCMaxValTest(src.String);

if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    IMAGEANLZ.(tab)(axnum).MinContrastMinUpdate(mincmin); 
    IMAGEANLZ.(tab)(axnum).ChangeMaxContrastVal(cmax);
    IMAGEANLZ.(tab)(axnum).ChangeMinContrastVal(cmin);
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider; 
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider;      
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).MinContrastMinUpdate(mincmin);
        IMAGEANLZ.(tab)(n).ChangeMaxContrastVal(cmax);
        IMAGEANLZ.(tab)(n).ChangeMinContrastVal(cmin);
    end
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider;
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider; 
end


