%===================================================
%
%===================================================
function ShadeROISlideChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation 
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
                IMAGEANLZ.(tab)(n).ShadeROIChangeValue(src.Value);
                IMAGEANLZ.(tab)(n).ShadeROIChangeSlider(src.Value);
                if IMAGEANLZ.(tab)(n).SAVEDROISFLAG == 1
                    IMAGEANLZ.(tab)(n).ChangeShadeSavedROIs;
                end
                if IMAGEANLZ.(tab)(n).GETROIS == 1
                    IMAGEANLZ.(tab)(n).ChangeShadeCurrentROI;
                end
            end
        else
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(src.Value);
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(src.Value);
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeSavedROIs;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeCurrentROI;
            end
        end
    case 'Ortho'
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(src.Value);
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeSavedROIs;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).ChangeShadeCurrentROI;
            end
        end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end




