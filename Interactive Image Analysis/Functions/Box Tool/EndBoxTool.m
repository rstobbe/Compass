%============================================
% NewBox
%============================================
function EndBoxTool(tab,axnum)

global IMAGEANLZ

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(axnum).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).ClearCurrentBox;
                IMAGEANLZ.(tab)(r).ClearCurrentBoxData;
                IMAGEANLZ.(tab)(r).EndBoxTool;
                IMAGEANLZ.(tab)(r).ResetStatus;
                IMAGEANLZ.(tab)(r).EnableOrient;
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.ForegroundColor = [0.149 0.149 0.241];
            end
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(1).ClearCurrentBox;
        IMAGEANLZ.(tab)(1).ClearCurrentBoxData;
        for r = 1:3
            IMAGEANLZ.(tab)(r).EndBoxTool;
            IMAGEANLZ.(tab)(r).ResetStatus;
        end
        IMAGEANLZ.(tab)(1).EnableOrient;
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.ForegroundColor = [0.149 0.149 0.241];
end
        

