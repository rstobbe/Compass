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
            end
        else
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(src.Value);
        end
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            Slice_Change(currentax,tab,axnum,0);
        end
    case 'Ortho'
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(src.Value);
            IMAGEANLZ.(tab)(axnum).PlotImage;
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIsNoPick([]);
                else
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                end
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).DrawTempROI([],[]);
            end
        end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end



