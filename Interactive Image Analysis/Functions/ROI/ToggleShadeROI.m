%============================================
% ToggleShadeROI
%============================================
function ToggleShadeROI(tab,axnum)

global IMAGEANLZ
if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

currentax = gca;
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        Shade = IMAGEANLZ.(tab)(axnum).ToggleShadeROI;
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(1).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            IMAGEANLZ.(tab)(r).ShadeROIChange(Shade);
            Slice_Change(currentax,tab,r,0);
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).ToggleShadeROI;
            Slice_Change(currentax,tab,r,0);
        end
end
        


