%============================================
% DeleteSelectedROIs
%============================================
function DeleteSelectedROIs(tab,axnum)

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
                DeleteRois = IMAGEANLZ.(tab)(r).TestActiveROIs;
                for ind = length(DeleteRois):-1:1
                    if DeleteRois(ind) == 1
                        roinum = ind;
                    else
                        continue
                    end
                    IMAGEANLZ.(tab)(r).DeleteROI(roinum);
                end
                IMAGEANLZ.(tab)(r).DeactivateAllROIs;
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
            end
        end
    case 'Ortho'
        for r = 1:3
            DeleteRois = IMAGEANLZ.(tab)(r).TestActiveROIs;
            for ind = length(DeleteRois):-1:1
                if DeleteRois(ind) == 1
                    roinum = ind;
                else
                    continue
                end
                IMAGEANLZ.(tab)(r).DeleteROI(roinum);
            end
            IMAGEANLZ.(tab)(r).DeactivateAllROIs;
            IMAGEANLZ.(tab)(r).PlotImage;
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]); 
            if IMAGEANLZ.(tab)(r).TestSavedLines
                IMAGEANLZ.(tab)(r).DrawSavedLines;
            end
        end
        DrawOrthoLines(tab);
end
