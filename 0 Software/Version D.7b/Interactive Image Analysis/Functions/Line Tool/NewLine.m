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
end
        
IMAGEANLZ.(tab)(axnum).UpdateStatus;

