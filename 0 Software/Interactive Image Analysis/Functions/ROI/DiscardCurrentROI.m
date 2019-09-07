%============================================
% 
%============================================
function DiscardCurrentROI(tab,axnum)

global IMAGEANLZ

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    return
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
                if IMAGEANLZ.(tab)(r).TestROIToolActive
                    IMAGEANLZ.(tab)(r).RestartROITool;
                end
                IMAGEANLZ.(tab)(r).DiscardCurrentROI;
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(r).EnableOrient;
                IMAGEANLZ.(tab)(r).ResetStatus;
                IMAGEANLZ.(tab)(r).FIGOBJS.MakeCurrentInvisible;
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
                IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
            end
        end
        for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
            IMAGEANLZ.(tab)(r).EnableTieing;
        end
    case 'Ortho'
        IMAGEANLZ.(tab)(1).RestartROITool;
        for r = 1:3
            IMAGEANLZ.(tab)(r).DiscardCurrentROI;
            IMAGEANLZ.(tab)(r).PlotImage;
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            if IMAGEANLZ.(tab)(r).TestSavedLines
                IMAGEANLZ.(tab)(r).DrawSavedLines;
            end
        end
        IMAGEANLZ.(tab)(1).EnableOrient;
        IMAGEANLZ.(tab)(1).ResetStatus;
        IMAGEANLZ.(tab)(1).FIGOBJS.MakeCurrentInvisible;
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
        DrawOrthoLines(tab);
end
IMAGEANLZ.(tab)(axnum).UpdateStatus;

