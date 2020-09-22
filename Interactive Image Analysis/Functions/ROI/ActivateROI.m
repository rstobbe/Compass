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

switch IMAGEANLZ.(tab)(axnum0).presentation 
    case 'Standard'
        currentax = gca;
        for axnum = start:stop
            if IMAGEANLZ.(tab)(axnum).TestAxisActive
                IMAGEANLZ.(tab)(axnum).ActivateROI(roinum);
                Slice_Change(currentax,tab,axnum,0);
            end
        end
        drawnow;
    case 'Ortho'
        for axnum = 1:3
            IMAGEANLZ.(tab)(axnum).ActivateROI(roinum);
            IMAGEANLZ.(tab)(axnum).PlotImage;
            if IMAGEANLZ.(tab)(axnum).SAVEDROISFLAG == 1
                if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIsNoPick([]);
                else
                    IMAGEANLZ.(tab)(axnum).DrawSavedROIs([]);
                end
            end
            if IMAGEANLZ.(tab)(axnum).GETROIS == 1
                IMAGEANLZ.(tab)(axnum).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(axnum).DrawTempROI([],[]);
            end
        end
end

%----------------------------------------
% OrthoPresentation 
%----------------------------------------
if IMAGEANLZ.(tab)(axnum).showortholine
    DrawOrthoLines(tab);
end
