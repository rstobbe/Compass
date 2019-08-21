%============================================
% DeleteROI
%============================================
function DeleteROI(tab,axnum,roinum)

global IMAGEANLZ

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(axnum).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).DeleteROI(roinum);
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
            end
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).DeleteROI(roinum);
            IMAGEANLZ.(tab)(r).PlotImage;
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
        end
        DrawOrthoLines(tab);
end

