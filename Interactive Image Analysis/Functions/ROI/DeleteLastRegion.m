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
            if IMAGEANLZ.(tab)(r).TestEmptyCurrentROI
                IMAGEANLZ.(tab)(r).SetROIEvent('Add')
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
            end
        end
        IMAGEANLZ.(tab)(axnum).TestUpdateCurrentROIValue;               % retain this focus
    case 'Ortho'
        if not(IMAGEANLZ.(tab)(1).TestEmptyTempROI)
            IMAGEANLZ.(tab)(1).ResetTempROI;
            if IMAGEANLZ.(tab)(1).TestROIToolActive
                IMAGEANLZ.(tab)(1).RestartROITool;
            end
        end
        for r = 1:3
            if IMAGEANLZ.(tab)(r).TestDeletedCurrentROI
                return
            end
            IMAGEANLZ.(tab)(r).DeleteLastRegion;
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
            if IMAGEANLZ.(tab)(r).TestEmptyCurrentROI
                IMAGEANLZ.(tab)(r).SetROIEvent('Add')
                IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
                IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
            end
        end
        IMAGEANLZ.(tab)(1).TestUpdateCurrentROIValue;
end

