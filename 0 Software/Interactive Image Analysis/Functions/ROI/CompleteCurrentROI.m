%============================================
% Complete_Current_ROI
%============================================
function CompleteCurrentROI(tab,axnum)

global IMAGEANLZ

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    return
end

if IMAGEANLZ.(tab)(axnum).GETROIS == 0
    error;          % shouldn't get here
end

if not(IMAGEANLZ.(tab)(axnum).TestFinishedCurrentROI) 
    Status2('warn','Finish ROI',3);
    return
end

roiname = inputdlg('Enter ROI Name: ');
if isempty(roiname)
    return
end
roiname = roiname{1};

test = 0;
n = 1;
while true
    for r = 1:IMAGEANLZ.(tab)(1).axeslen
        if n <= length(IMAGEANLZ.(tab)(r).SAVEDROIS)
            if not(isempty(IMAGEANLZ.(tab)(r).SAVEDROIS))
                test = test + 1;
            end
        end
    end
    if test > 0
        n = n+1;
        test = 0;
    else
        break
    end
end
if n > 35 
    Status2('error','No available space to put ROI',3);
    return
end
roi = n;

switch IMAGEANLZ.(tab)(axnum).presentation
    case 'Standard'
        if IMAGEANLZ.(tab)(axnum).ROITIE == 1
            start = 1;    
            stop = IMAGEANLZ.(tab)(1).axeslen;
        else
            start = axnum;
            stop = axnum;
        end
        for r = start:stop
            if IMAGEANLZ.(tab)(r).TestAxisActive
                IMAGEANLZ.(tab)(r).CompleteCurrentROI(roi,roiname);
                IMAGEANLZ.(tab)(r).PlotImage;
                IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
                IMAGEANLZ.(tab)(r).SetSavedROIValues;
                IMAGEANLZ.(tab)(r).EnableOrient;
                IMAGEANLZ.(tab)(r).ResetStatus;
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
                IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8,0.8,0.8];
                IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
                IMAGEANLZ.(tab)(r).FIGOBJS.MakeCurrentInvisible;
            end
        end
        for r = 1:IMAGEANLZ.(tab)(1).axeslen
            IMAGEANLZ.(tab)(r).EnableTieing;
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).CompleteCurrentROI(roi,roiname);
            IMAGEANLZ.(tab)(r).PlotImage;
            IMAGEANLZ.(tab)(r).DrawSavedROIs([]);
            IMAGEANLZ.(tab)(r).ResetStatus;
            if IMAGEANLZ.(tab)(r).TestSavedLines
                IMAGEANLZ.(tab)(r).DrawSavedLines;
            end
        end
        IMAGEANLZ.(tab)(1).SetSavedROIValues;
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.MakeCurrentInvisible;
        DrawOrthoLines(tab);
end

IMAGEANLZ.(tab)(axnum).UpdateStatus;
