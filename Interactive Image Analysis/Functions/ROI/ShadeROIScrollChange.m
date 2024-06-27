%===================================================
%
%===================================================
function ShadeROIScrollChange(tab,axnum,event)

global IMAGEANLZ

SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            newshadevalue = IMAGEANLZ.(tab)(axnum).shaderoivalue - event.VerticalScrollCount/20;
            for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
                if newshadevalue > 1
                    newshadevalue = 1;
                elseif newshadevalue < 0.05
                    newshadevalue = 0.05;
                end
                IMAGEANLZ.(tab)(n).ShadeROIChangeValue(newshadevalue);
                IMAGEANLZ.(tab)(n).ShadeROIChangeSlider(newshadevalue);
                if IMAGEANLZ.(tab)(n).SAVEDROISFLAG == 1
                    IMAGEANLZ.(tab)(n).ChangeShadeSavedROIs;
                end
                if IMAGEANLZ.(tab)(n).GETROIS == 1
                    IMAGEANLZ.(tab)(n).ChangeShadeCurrentROI;
                end
            end
        else
            newshadevalue = IMAGEANLZ.(tab)(axnum).shaderoivalue - event.VerticalScrollCount/20; 
            if newshadevalue > 1
                newshadevalue = 1;
            elseif newshadevalue < 0.05
                newshadevalue = 0.05;
            end
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(newshadevalue);
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(newshadevalue);
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeSavedROIs;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeCurrentROI;
            end
        end
    case 'Ortho'
        newshadevalue = IMAGEANLZ.(tab)(axnum).shaderoivalue - event.VerticalScrollCount/20;
        if newshadevalue > 1
            newshadevalue = 1;
        elseif newshadevalue < 0.05
            newshadevalue = 0.05;
        end
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(newshadevalue);
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeSavedROIs;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeCurrentROI;
            end
        end
end
SetFocus(tab,axnum);

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




