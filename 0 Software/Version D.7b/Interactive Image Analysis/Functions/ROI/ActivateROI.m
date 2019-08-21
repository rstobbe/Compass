%===================================================
% Activate_ROI
%===================================================
function ActivateROI(src,tab,axnum0,roinum)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum0).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(1).axeslen;
else
    start = axnum0;
    stop = axnum0;
end

for axnum = start:stop
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum) = 1;
        IMAGEANLZ.(tab)(axnum).HighlightROI(roinum);
    end
end
drawnow;