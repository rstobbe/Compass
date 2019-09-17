%===================================================
% Edit_ROI
%===================================================
function EditROI(tab,axnum,roinum)

global IMAGEANLZ

IMAGEANLZ.(tab)(axnum).NewROICreate;
IMAGEANLZ.(tab)(axnum).DisableOrient;

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
                if r ~= axnum
                    IMAGEANLZ.(tab)(r).NewROICopy(IMAGEANLZ.(tab)(axnum).CURRENTROI,IMAGEANLZ.(tab)(axnum).TEMPROI);
                end
                IMAGEANLZ.(tab)(r).CopySavedRoi2Current(roinum);
                IMAGEANLZ.(tab)(r).DeactivateROI(roinum);
                if(IMAGEANLZ.(tab)(r).TestMaskOnlyCurrentROI)
                    IMAGEANLZ.(tab)(r).InitiateRedrawROI;
                    IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.6,0.2,0.2];
                    IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [1 1 1];
                else
                    IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.BackgroundColor = [0.12,0.35,0.23];
                    IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.ForegroundColor = [1 1 1];
                end
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawSavedROIsNoPick([]);
                IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
                IMAGEANLZ.(tab)(r).ComputeCurrentROI;
                IMAGEANLZ.(tab)(r).SetCurrentROIValue; 
            end
        end
        for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
            IMAGEANLZ.(tab)(r).DisableTieing;
        end
    case 'Ortho'
        ROITOOL = IMAGEANLZ.(tab)(1).GetROITool;
        IMAGEANLZ.(tab)(axnum).NewROICreateOrtho(ROITOOL);
        for r = 1:3
            if r ~= axnum
                IMAGEANLZ.(tab)(r).NewROICopyOrtho(IMAGEANLZ.(tab)(axnum).CURRENTROI,IMAGEANLZ.(tab)(axnum).TEMPROI);
            end
        end
        for r = 1:3
            IMAGEANLZ.(tab)(r).CopySavedRoi2Current(roinum);
            IMAGEANLZ.(tab)(r).DrawSavedROIsNoPick([]);
            IMAGEANLZ.(tab)(r).DrawCurrentROI([]);
        end
        IMAGEANLZ.(tab)(1).ComputeCurrentROI;
        IMAGEANLZ.(tab)(1).SetCurrentROIValue;
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.BackgroundColor = [0.12,0.35,0.23];
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.ForegroundColor = [1 1 1]; 
end
        
IMAGEANLZ.(tab)(axnum).UpdateStatus;
