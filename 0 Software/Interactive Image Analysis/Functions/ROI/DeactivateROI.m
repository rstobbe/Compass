%===================================================
% 
%===================================================
function DeactivateROI(src,tab,axnum0,roinum)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum0).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(1).axeslen;
else
    start = axnum0;
    stop = axnum0;
end

currentax = gca;
for axnum = start:stop
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        IMAGEANLZ.(tab)(axnum).DeactivateROI(roinum);
        Slice_Change(currentax,tab,axnum,0);
    end
end
drawnow;