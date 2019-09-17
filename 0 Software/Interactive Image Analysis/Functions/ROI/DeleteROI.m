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
        activerois = IMAGEANLZ.(tab)(axnum).TestActiveROIs;
        activerois(roinum) = 0;
        activerois = find(activerois);
        newactiverois = activerois;
        newactiverois(newactiverois>roinum) = newactiverois(newactiverois>roinum)-1;
       for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).DeleteROI(roinum);
                IMAGEANLZ.(tab)(r).DeactivateAllROIs;
                for n = 1:length(newactiverois)
                    IMAGEANLZ.(tab)(r).ActivateROI(newactiverois(n));
                end
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
            if IMAGEANLZ.(tab)(r).TestSavedLines
                IMAGEANLZ.(tab)(r).DrawSavedLines;
            end
        end
        DrawOrthoLines(tab);
end

