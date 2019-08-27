%============================================
% Delete_Last_Region
%============================================
function DeleteLastRegion(tab,axnum)

global IMAGEANLZ

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    return
end

if IMAGEANLZ.(tab)(axnum).GETROIS == 0
    error;          % shouldn't get here
end

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(1).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            if not(IMAGEANLZ.(tab)(r).TestEmptyTempROI)
                IMAGEANLZ.(tab)(r).ResetTempROI;
                if IMAGEANLZ.(tab)(r).TestROIToolActive
                    IMAGEANLZ.(tab)(r).RestartROITool;
                end
            else
                IMAGEANLZ.(tab)(r).DeleteLastRegion;
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(r).TestUpdateCurrentROIValue;
            end
        end
    case 'Ortho'
        if not(IMAGEANLZ.(tab)(1).TestEmptyTempROI)
            IMAGEANLZ.(tab)(1).ResetTempROI;
            if IMAGEANLZ.(tab)(1).TestROIToolActive
                IMAGEANLZ.(tab)(1).RestartROITool;
            end
        end
        for r = 1:3
            IMAGEANLZ.(tab)(r).DeleteLastRegion;
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
        end
        IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
end