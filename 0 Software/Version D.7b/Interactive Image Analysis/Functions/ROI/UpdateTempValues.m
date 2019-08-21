%============================================
% 
%============================================
function UpdateTempValues(tab,axnum)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

%---
showcurrentroionall = 1;            % to switch on panel
%---
if showcurrentroionall == 1
    for r = start:stop
        if IMAGEANLZ.(tab)(r).TestAxisActive
            if not(IMAGEANLZ.(tab)(r).TestEmptyTempROI)
                IMAGEANLZ.(tab)(r).CreateTempROIMask;
                IMAGEANLZ.(tab)(r).ComputeTempROI;
                mean = IMAGEANLZ.(tab)(r).TEMPROI.roimean
            end
        end
    end
else
    if not(IMAGEANLZ.(tab)(axnum).TestEmptyTempROI)
        IMAGEANLZ.(tab)(axnum).CreateTempROIMask;
        IMAGEANLZ.(tab)(axnum).ComputeTempROI;
        mean = IMAGEANLZ.(tab)(axnum).TEMPROI.roimean
    end
end