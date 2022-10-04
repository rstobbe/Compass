%============================================
% Draw Box
%============================================
function DrawBox(tab,axnum,x,y)

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
    IMAGEANLZ.(tab)(axnum).CurrentBoxDrawError;
    switch IMAGEANLZ.(tab)(axnum).presentation
        case 'Standard'
            for r = start:stop
                if IMAGEANLZ.(tab)(r).TestAxisActive
                    IMAGEANLZ.(tab)(r).CurrentBoxDrawErrorWrite;
                    IMAGEANLZ.(tab)(r).movefunction = '';
                    IMAGEANLZ.(tab)(r).CurrentBoxDrawError;
                end
            end
        case 'Ortho'
            IMAGEANLZ.(tab)(1).CurrentBoxDrawErrorWrite;
    end
    return
end
    
%----------------------------------------
% Draw Box
%----------------------------------------
switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).RecordBoxInfo(x,y);
                IMAGEANLZ.(tab)(r).DrawCurrentBox;
                IMAGEANLZ.(tab)(r).WriteCurrentBoxData(IMAGEANLZ.(tab)(axnum).CURRENTBOX);
            end
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(axnum).RecordBoxInfo(x,y);
        IMAGEANLZ.(tab)(axnum).DrawCurrentBox;
        IMAGEANLZ.(tab)(1).WriteCurrentBoxData(IMAGEANLZ.(tab)(axnum).CURRENTBOX);
end

