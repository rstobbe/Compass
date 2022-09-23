%============================================
% NewLine
%============================================
function NewLine(tab,axnum)

global IMAGEANLZ

IMAGEANLZ.(tab)(axnum).DisableOrient;

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
                IMAGEANLZ.(tab)(r).NewLineCreate;
                IMAGEANLZ.(tab)(r).UpdateStatus;
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.BackgroundColor = [0.12,0.35,0.23];
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateLineTool.ForegroundColor = [1 1 1]; 
            end
        end
        for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
            IMAGEANLZ.(tab)(r).DisableTieing;
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).NewLineCreateOrtho;
        end
        IMAGEANLZ.(tab)(1).UpdateStatus;
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.BackgroundColor = [0.12,0.35,0.23];
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.ForegroundColor = [1 1 1]; 
end
        