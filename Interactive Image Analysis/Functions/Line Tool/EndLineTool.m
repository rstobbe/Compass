%============================================
% NewLine
%============================================
function EndLineTool(tab,axnum)

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
                IMAGEANLZ.(tab)(r).ClearCurrentLine;
                IMAGEANLZ.(tab)(r).ClearCurrentLineData;
                IMAGEANLZ.(tab)(r).EndLineTool;
                IMAGEANLZ.(tab)(r).ResetStatus;
                IMAGEANLZ.(tab)(r).EnableOrient;
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.ForegroundColor = [0.149 0.149 0.241];
            end
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(1).ClearCurrentLine;
        IMAGEANLZ.(tab)(1).ClearCurrentLineData;
        for r = 1:3
            IMAGEANLZ.(tab)(r).EndLineTool;
            IMAGEANLZ.(tab)(r).ResetStatus;
        end
        IMAGEANLZ.(tab)(1).EnableOrient;
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.ForegroundColor = [0.149 0.149 0.241];
end
        

