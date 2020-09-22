%============================================
% NewLine
%============================================
function EndLineTool(tab,axnum)

global IMAGEANLZ

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'

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
        

