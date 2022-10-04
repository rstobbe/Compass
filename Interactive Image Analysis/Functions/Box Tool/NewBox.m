%============================================
% NewBox
%============================================
function NewBox(tab,axnum)

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
                IMAGEANLZ.(tab)(r).NewBoxCreate;
                IMAGEANLZ.(tab)(r).UpdateStatus;
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.12,0.35,0.23];
                IMAGEANLZ.(tab)(r).FIGOBJS.ActivateBoxTool.ForegroundColor = [1 1 1]; 
            end
        end
        for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
            IMAGEANLZ.(tab)(r).DisableTieing;
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).NewBoxCreateOrtho;
        end
        IMAGEANLZ.(tab)(1).UpdateStatus;
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.BackgroundColor = [0.12,0.35,0.23];
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateBoxTool.ForegroundColor = [1 1 1]; 
end
        