%============================================
% Draw Line
%============================================
function DrawLine(tab,axnum,x,y)

global IMAGEANLZ

%----------------------------------------
% Data point
%----------------------------------------
z = IMAGEANLZ.(tab)(axnum).SLICE;
mouseloc = [x,y,z];

%----------------------------------------
% Test Within Boundary
%----------------------------------------
if not(IMAGEANLZ.(tab)(axnum).TestMouseInImage(mouseloc))
    IMAGEANLZ.(tab)(axnum).movefunction = '';
    IMAGEANLZ.(tab)(axnum).CurrentLineDrawError;
    switch IMAGEANLZ.(tab)(axnum).presentation
        case 'Standard'
            IMAGEANLZ.(tab)(axnum).CurrentLineDrawErrorWrite;
        case 'Ortho'
            IMAGEANLZ.(tab)(1).CurrentLineDrawErrorWrite;
    end
    return
end
    
%----------------------------------------
% Draw Line
%----------------------------------------
IMAGEANLZ.(tab)(axnum).RecordLineInfo(x,y);
IMAGEANLZ.(tab)(axnum).DrawCurrentLine;
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        IMAGEANLZ.(tab)(axnum).WriteCurrentLineData(IMAGEANLZ.(tab)(axnum).CURRENTLINE);
    case 'Ortho'
        IMAGEANLZ.(tab)(1).WriteCurrentLineData(IMAGEANLZ.(tab)(axnum).CURRENTLINE);
end

