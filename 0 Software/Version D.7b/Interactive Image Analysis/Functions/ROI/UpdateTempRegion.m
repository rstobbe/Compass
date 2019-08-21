%============================================
% 
%============================================
function UpdateTempRegion(OUT,tab,axnum)

global IMAGEANLZ

%---
showcurrentroionall = 1;            % to switch on panel
%---
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(axnum).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        if showcurrentroionall == 1
            for r = start:stop
                if IMAGEANLZ.(tab)(r).TestAxisActive
                    IMAGEANLZ.(tab)(r).UpdateTempROI(OUT);
                    IMAGEANLZ.(tab)(r).DrawTempROI([],OUT.clr);
                end
            end
        else
            IMAGEANLZ.(tab)(axnum).UpdateTempROI(OUT);
            IMAGEANLZ.(tab)(axnum).DrawTempROI([],OUT.clr);
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).UpdateTempROI(OUT);
            IMAGEANLZ.(tab)(r).DrawTempROI([],OUT.clr);
        end
        if IMAGEANLZ.(tab)(1).autoupdateroi 
            IMAGEANLZ.(tab)(1).UpdateTempROIValues;
        end
end