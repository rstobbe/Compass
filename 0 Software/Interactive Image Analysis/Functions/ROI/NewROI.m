%============================================
% NewROI
%============================================
function NewROI(tab,axnum)

global IMAGEANLZ
global FIGOBJS

IMAGEANLZ.(tab)(axnum).DisableOrient;

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        IMAGEANLZ.(tab)(axnum).NewROICreate;
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
                IMAGEANLZ.(tab)(r).DrawSavedROIsNoPick([]);
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.BackgroundColor = [0.12,0.35,0.23];
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.ForegroundColor = [1 1 1]; 
                FIGOBJS.(tab).ControlTab(r).SelectedTab = FIGOBJS.(tab).ROITab(r);
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
            IMAGEANLZ.(tab)(r).DrawSavedROIsNoPick([]);
        end
        IMAGEANLZ.(tab)(1).FIGOBJS.MakeCurrentVisible;
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.BackgroundColor = [0.12,0.35,0.23];
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.ForegroundColor = [1 1 1]; 
end
        
IMAGEANLZ.(tab)(axnum).UpdateStatus;

