%===================================================
% 
%===================================================
function ShadeROISlideChange2(src,event)

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
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
                IMAGEANLZ.(tab)(n).ShadeROIChangeValue(event.AffectedObject.Value);
                IMAGEANLZ.(tab)(n).ShadeROIChangeSlider(event.AffectedObject.Value);
            end
        else
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(event.AffectedObject.Value);
        end
        if IMAGEANLZ.(tab)(axnum).TestAxisActive
            Slice_Change(currentax,tab,axnum,0);
        end
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(event.AffectedObject.Value);
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

