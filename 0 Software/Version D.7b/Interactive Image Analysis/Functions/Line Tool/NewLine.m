%============================================
% NewLine
%============================================
function NewLine(tab,axnum)

global IMAGEANLZ

IMAGEANLZ.(tab)(axnum).DisableOrient;

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'

    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).NewLineCreateOrtho;
        end
        IMAGEANLZ.(tab)(1).UpdateStatus;
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.BackgroundColor = [0.12,0.35,0.23];
        IMAGEANLZ.(tab)(1).FIGOBJS.ActivateLineTool.ForegroundColor = [1 1 1]; 
end
        