%============================================
% EraseROI
%============================================
function EraseROI(tab,axnum)

global IMAGEANLZ
if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
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
            Event = IMAGEANLZ.(tab)(r).ToggleROIEvent;
            if strcmp(Event,'Add')
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
            elseif strcmp(Event,'Erase')
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.6,0.2,0.2];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [1 1 1];
            end
        end
    case 'Ortho'
        for r = 1:3
            Event = IMAGEANLZ.(tab)(r).ToggleRoiEvent;
        end
        if strcmp(Event,'Add')
            IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
        elseif strcmp(Event,'Erase')
            IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.6,0.2,0.2];
            IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [1 1 1];
        end
end
        


