%===================================================
% 
%===================================================
function ContrastMin(src,event)

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
if strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Standard')
   for r = 1:2
        if IMAGEANLZ.(tab)(r).TieContrast == 1
            IMAGEANLZ.(tab)(1).ChangeMinContrastRel(src.Value);
            IMAGEANLZ.(tab)(2).ChangeMinContrastRel(src.Value);
        end
    end
    IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(src.Value);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(src.Value); 
    end
end
