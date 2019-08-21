%===================================================
%
%===================================================
function ComplexAverageROIChange(src,event)

global IMAGEANLZ

tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
                IMAGEANLZ.(tab)(n).ComplexAverageROIChange(src.Value);
                if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                    IMAGEANLZ.(tab)(n).DrawSavedROIs([]);
                    IMAGEANLZ.(tab)(n).ComputeAllSavedROIs;
                    IMAGEANLZ.(tab)(n).SetSavedROIValues;
                end
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(n).DrawCurrentROI([]);
                    IMAGEANLZ.(tab)(n).ComputeCurrentROI;
                    IMAGEANLZ.(tab)(n).SetCurrentROIValue;
                end
            end
        else
            IMAGEANLZ.(tab)(axnum).ComplexAverageROIChange(src.Value);
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
                IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
                IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
            end
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(1).ComplexAverageROIChange(src.Value);
        if IMAGEANLZ.(tab)(1).SAVEDROISFLAG == 1
            IMAGEANLZ.(tab)(1).DrawSavedROIs([]);
            IMAGEANLZ.(tab)(1).ComputeAllSavedROIs;
            IMAGEANLZ.(tab)(1).SetSavedROIValues;
        end
        if IMAGEANLZ.(tab)(1).GETROIS == 1
            IMAGEANLZ.(tab)(1).DrawCurrentROI([]);
            IMAGEANLZ.(tab)(1).ComputeCurrentROI;
            IMAGEANLZ.(tab)(1).SetCurrentROIValue;
        end
end

