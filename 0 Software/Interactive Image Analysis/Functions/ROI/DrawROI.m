%============================================
% Draw ROI
%============================================
function DrawROI(tab,axnum,x,y)

global IMAGEANLZ

%----------------------------------------
% Data point
%----------------------------------------
z = IMAGEANLZ.(tab)(axnum).SLICE;
mouseloc = [x,y,z];

%----------------------------------------
% Test Within Boundary
%----------------------------------------
if not(IMAGEANLZ.(tab)(axnum).TestMouseInImage(mouseloc));
    IMAGEANLZ.(tab)(axnum).movefunction = '';
    IMAGEANLZ.(tab)(axnum).TEMPROI.DrawError;
end
    
%----------------------------------------
% Draw ROI
%----------------------------------------
clr = 'r';
axhand = IMAGEANLZ.(tab)(axnum).GetAxisHandle;
IMAGEANLZ.(tab)(axnum).TEMPROI.DrawLine(mouseloc,axhand,clr);




