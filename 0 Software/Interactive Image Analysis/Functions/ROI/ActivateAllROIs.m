%===================================================
% 
%===================================================
function ActivateAllROIs(tab,axnum0)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum0).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(1).axeslen;
else
    start = axnum0;
    stop = axnum0;
end

for axnum = start:stop
    for n = 1:length(IMAGEANLZ.(tab)(axnum).SAVEDROIS)
        IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(n) = 1;
        IMAGEANLZ.(tab)(axnum).HighlightROI(n);
    end
end
drawnow;