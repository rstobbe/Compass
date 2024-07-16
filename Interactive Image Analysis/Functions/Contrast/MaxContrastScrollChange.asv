%===================================================
%
%===================================================
function MaxContrastScrollChange(tab,axnum,event)

global IMAGEANLZ

SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard' 
        newcontrastvalue = IMAGEANLZ.(tab)(axnum).RelContrast(2) + event.VerticalScrollCount/20;
        if newcontrastvalue < 0
            newcontrastvalue = 0;
        elseif newcontrastvalue > 1
            newcontrastvalue = 1;
        end
        for r = 1:2
            if IMAGEANLZ.(tab)(r).TieContrast == 1
                IMAGEANLZ.(tab)(1).ChangeMaxContrastRel(newcontrastvalue);
                IMAGEANLZ.(tab)(2).ChangeMaxContrastRel(newcontrastvalue);
            end
        end
        IMAGEANLZ.(tab)(axnum).ChangeMaxContrastRel(newcontrastvalue);
    case 'Ortho'
        for axnum = 1:3
            newcontrastvalue = IMAGEANLZ.(tab)(axnum).RelContrast(2) + event.VerticalScrollCount/20;
            if newcontrastvalue < 0
                newcontrastvalue = 0;
            elseif newcontrastvalue > 1
                newcontrastvalue = 1;
            end
            IMAGEANLZ.(tab)(axnum).ChangeMaxContrastRel(newcontrastvalue);
        end

end
%SetFocus(tab,axnum);

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




