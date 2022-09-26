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

if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

%----------------------------------------
% Test Within Boundary
%----------------------------------------
if not(IMAGEANLZ.(tab)(axnum).TestMouseInImage(mouseloc))
    IMAGEANLZ.(tab)(axnum).movefunction = '';
    IMAGEANLZ.(tab)(axnum).CurrentLineDrawError;
    switch IMAGEANLZ.(tab)(axnum).presentation
        case 'Standard'
            for r = start:stop
                if IMAGEANLZ.(tab)(r).TestAxisActive
                    IMAGEANLZ.(tab)(r).CurrentLineDrawErrorWrite;
                    IMAGEANLZ.(tab)(r).movefunction = '';
                    IMAGEANLZ.(tab)(r).CurrentLineDrawError;
                end
            end
        case 'Ortho'
            IMAGEANLZ.(tab)(1).CurrentLineDrawErrorWrite;
    end
    return
end
    
%----------------------------------------
% Draw Line
%----------------------------------------
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).RecordLineInfo(x,y);
                IMAGEANLZ.(tab)(r).DrawCurrentLine;
                IMAGEANLZ.(tab)(r).WriteCurrentLineData(IMAGEANLZ.(tab)(axnum).CURRENTLINE);
            end
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(axnum).RecordLineInfo(x,y);
        IMAGEANLZ.(tab)(axnum).DrawCurrentLine;
        IMAGEANLZ.(tab)(1).WriteCurrentLineData(IMAGEANLZ.(tab)(axnum).CURRENTLINE);
end

