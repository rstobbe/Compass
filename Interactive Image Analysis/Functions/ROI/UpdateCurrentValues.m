%============================================
% 
%============================================
function UpdateCurrentValues(tab,axnum)

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
            IMAGEANLZ.(tab)(r).CreateCurrentROIMask;
            IMAGEANLZ.(tab)(r).ComputeCurrentROI;
            IMAGEANLZ.(tab)(r).SetCurrentROIValue;
        end
    end
else
    IMAGEANLZ.(tab)(axnum).CreateCurrentROIMask;
    IMAGEANLZ.(tab)(axnum).ComputeCurrentROI;
    IMAGEANLZ.(tab)(axnum).SetCurrentROIValue;
end