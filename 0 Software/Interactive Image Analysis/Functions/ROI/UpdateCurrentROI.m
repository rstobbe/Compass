%============================================
% 
%============================================
function UpdateCurrentROI(tab,axnum)

global IMAGEANLZ

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end
if IMAGEANLZ.(tab)(axnum).GETROIS == 0
    error;          % shouldn't get here
end

if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(1).axeslen;
else
    start = axnum;
    stop = axnum;
end

for r = start:stop
    IMAGEANLZ.(tab)(r).ComputeCurrentROI;
    IMAGEANLZ.(tab)(r).SetCurrentROIValue;
end
