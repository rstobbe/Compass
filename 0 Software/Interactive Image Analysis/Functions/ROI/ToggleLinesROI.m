%============================================
% ToggleLinesROI
%============================================
function ToggleLinesROI(tab,axnum)

global IMAGEANLZ
if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

currentax = gca;
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        Lines = IMAGEANLZ.(tab)(axnum).ToggleLinesROI;
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(1).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            IMAGEANLZ.(tab)(r).LinesROIChange(Lines);
            Slice_Change(currentax,tab,r,0);
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).ToggleLinesROI;
            Slice_Change(currentax,tab,r,0);
        end
end
        


