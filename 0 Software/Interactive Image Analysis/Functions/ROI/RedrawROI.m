%============================================
% RedrawROI
%============================================
function RedrawROI(tab,axnum)

global IMAGEANLZ

if not(IMAGEANLZ.(tab)(axnum).TestFinishedCurrentROI) 
    Status2('warn','No ROI to Redraw',3);
    return
end

currentax = gca;
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
            IMAGEANLZ.(tab)(r).InitiateRedrawROI;
            IMAGEANLZ.(tab)(r).UpdateStatus;
            IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
            IMAGEANLZ.(tab)(r).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
            IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
            IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
            IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.6,0.2,0.2];
            IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [1 1 1];
            Slice_Change(currentax,tab,r,0);
        end
    case 'Ortho'
        for r = 1:3
            IMAGEANLZ.(tab)(r).InitiateRedrawROI;
            IMAGEANLZ.(tab)(r).UpdateStatus;
        end
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.NewROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.6,0.2,0.2];
        IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.ForegroundColor = [1 1 1];
        Slice_Change(currentax,tab,1,0);
end









