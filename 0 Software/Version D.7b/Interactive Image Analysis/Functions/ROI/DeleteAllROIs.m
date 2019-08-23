%============================================
% 
%============================================
function DeleteAllROIs(tab,axnum)

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
                IMAGEANLZ.(tab)(r).DeleteAllSavedROIs;
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
                for roinum = 1:35
                    IMAGEANLZ.(tab)(r).ROISOFINTEREST(roinum) = 0;
                    IMAGEANLZ.(tab)(r).UnHighlightROI(roinum);
                end
            end
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).DeleteAllSavedROIs;
            IMAGEANLZ.(tab)(r).PlotImage;
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
            if IMAGEANLZ.(tab)(r).TestSavedLines
                IMAGEANLZ.(tab)(r).DrawSavedLines;
            end
        end
        for roinum = 1:35
            IMAGEANLZ.(tab)(1).ROISOFINTEREST(roinum) = 0;
            IMAGEANLZ.(tab)(1).UnHighlightROI(roinum);
        end
        DrawOrthoLines(tab);
end

