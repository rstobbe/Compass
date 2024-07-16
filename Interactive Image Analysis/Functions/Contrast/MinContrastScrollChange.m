%===================================================
%
%===================================================
function MinContrastScrollChange(tab,axnum,event)

global IMAGEANLZ

SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard'
        newcontrastvalue = IMAGEANLZ.(tab)(axnum).RelContrast(1) + event.VerticalScrollCount/20;
        if newcontrastvalue < 0
            newcontrastvalue = 0;
        elseif newcontrastvalue > 1
            newcontrastvalue = 1;
        end
        if IMAGEANLZ.(tab)(axnum).TieContrast
            otherax = 1;
            if axnum == 1
                otherax = 2;
            end
            IMAGEANLZ.(tab)(otherax).ChangeMinContrastRel(newcontrastvalue);
        end
        IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(newcontrastvalue);
    case 'Ortho'
        for axnum = 1:3
            newcontrastvalue = IMAGEANLZ.(tab)(axnum).RelContrast(1) + event.VerticalScrollCount/20;
            if newcontrastvalue < 0
                newcontrastvalue = 0;
            elseif newcontrastvalue > 1
                newcontrastvalue = 1;
            end
            IMAGEANLZ.(tab)(axnum).ChangeMinContrastRel(newcontrastvalue);
        end

end
%SetFocus(tab,axnum);

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




