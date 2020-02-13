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
        start = 1;    
        stop = IMAGEANLZ.(tab)(axnum).axeslen;
    else
        start = axnum;
        stop = axnum;
    end
    for n = start:stop
        IMAGEANLZ.(tab)(n).ShadeROIChangeValue(event.AffectedObject.Value);
        %IMAGEANLZ.(tab)(n).ShadeROIChangeSlider(event.AffectedObject.Value);
        if IMAGEANLZ.(tab)(n).SAVEDROISFLAG == 1
            IMAGEANLZ.(tab)(n).ChangeShadeSavedROIs;
        end
        if IMAGEANLZ.(tab)(n).GETROIS == 1
            IMAGEANLZ.(tab)(n).ChangeShadeCurrentROI;
        end
    end
elseif strcmp(IMAGEANLZ.(tab)(axnum).presentation,'Ortho')
    for axnum = 1:3
        IMAGEANLZ.(tab)(axnum).ShadeROIChangeValue(event.AffectedObject.Value);
        if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
            IMAGEANLZ.(tab)(axnum).ChangeShadeSavedROIs;
        end
        if IMAGEANLZ.(tab)(axnum).GETROIS == 1
            IMAGEANLZ.(tab)(axnum).ChangeShadeCurrentROI;
        end
    end
end

