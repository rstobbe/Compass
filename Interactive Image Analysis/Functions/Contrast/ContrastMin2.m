%===================================================
% 
%===================================================
function ContrastMin2(src,event)

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
    for r = 1:2
        if IMAGEANLZ.(tab)(r).TieContrast == 1
            IMAGEANLZ.(tab)(1).ChangeMinContrastRel(event.AffectedObject.Value);
            IMAGEANLZ.(tab)(2).ChangeMinContrastRel(event.AffectedObject.Value);
        end
    end
    IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(event.AffectedObject.Value);
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(event.AffectedObject.Value);
    end
end
