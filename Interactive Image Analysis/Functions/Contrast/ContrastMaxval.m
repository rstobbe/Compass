%===================================================
% 
%===================================================
function ContrastMaxval(src,event)

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

IMAGEANLZ.(tab)(axnum).CMaxValUserEdit;
maxcmax = IMAGEANLZ.(tab)(axnum).MaxCMaxValTest(src.String);

if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    for r = 1:2
        if IMAGEANLZ.(tab)(r).TieContrast == 1
            IMAGEANLZ.(tab)(1).MaxContrastMaxUpdate(maxcmax); 
            IMAGEANLZ.(tab)(1).ChangeMaxContrastVal(str2double(src.String));
            IMAGEANLZ.(tab)(1).UpdateMaxContrastSlider; 
            IMAGEANLZ.(tab)(2).MaxContrastMaxUpdate(maxcmax); 
            IMAGEANLZ.(tab)(2).ChangeMaxContrastVal(str2double(src.String));
            IMAGEANLZ.(tab)(2).UpdateMaxContrastSlider; 
        end
    end
    IMAGEANLZ.(tab)(axnum).MaxContrastMaxUpdate(maxcmax); 
    IMAGEANLZ.(tab)(axnum).ChangeMaxContrastVal(str2double(src.String));
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider;    
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).MaxContrastMaxUpdate(maxcmax);
        IMAGEANLZ.(tab)(n).ChangeMaxContrastVal(str2double(src.String));
    end
    IMAGEANLZ.(tab)(axnum).UpdateMaxContrastSlider; 
end


