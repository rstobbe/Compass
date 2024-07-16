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

%--------------------------------------------
% Change Contrast
%--------------------------------------------
if isnan(str2double(src.String))
    return
end
SetFocus(tab,axnum);

IMAGEANLZ.(tab)(axnum).CMinValUserEdit;
mincmin = IMAGEANLZ.(tab)(axnum).MinCMinValTest(src.String);

if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
    for r = 1:2
        if IMAGEANLZ.(tab)(r).TieContrast == 1
            IMAGEANLZ.(tab)(1).MinContrastMinUpdate(mincmin); 
            IMAGEANLZ.(tab)(1).ChangeMinContrastVal(str2double(src.String));
            IMAGEANLZ.(tab)(1).UpdateMinContrastSlider; 
            IMAGEANLZ.(tab)(2).MinContrastMinUpdate(mincmin); 
            IMAGEANLZ.(tab)(2).ChangeMinContrastVal(str2double(src.String));
            IMAGEANLZ.(tab)(2).UpdateMinContrastSlider; 
        end
    end
    IMAGEANLZ.(tab)(axnum).MinContrastMinUpdate(mincmin); 
    IMAGEANLZ.(tab)(axnum).ChangeMinContrastVal(str2double(src.String));
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider;    
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for n = 1:3
        IMAGEANLZ.(tab)(n).MinContrastMinUpdate(mincmin);
        IMAGEANLZ.(tab)(n).ChangeMinContrastVal(str2double(src.String));
    end
    IMAGEANLZ.(tab)(axnum).UpdateMinContrastSlider; 
end











