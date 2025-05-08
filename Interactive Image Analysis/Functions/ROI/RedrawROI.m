%============================================
% RedrawROI
%============================================
function RedrawROI(tab,axnum)

global IMAGEANLZ

Exit = 0;
if not(IMAGEANLZ.(tab)(axnum).TestFinishedCurrentROI) 
    if IMAGEANLZ.(tab)(axnum).redrawroi == 0
        Status2('warn','No ROI to Redraw',3);
        return
    else
        Exit = 1;
    end
end
if IMAGEANLZ.(tab)(axnum).androi == 1
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
            if IMAGEANLZ.(tab)(r).TestAxisActive
                if Exit == 1
                    IMAGEANLZ.(tab)(r).ExitRedrawROI;
                    Slice_Change(currentax,tab,r,0);
                    IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8,0.8,0.8];
                    IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
                else
                    ReDraw = IMAGEANLZ.(tab)(r).ToggleROIRedrawEvent;
                    if ~ReDraw
                        IMAGEANLZ.(tab)(r).ReturnRedrawROI;
                        IMAGEANLZ.(tab)(r).UpdateStatus;
                        Slice_Change(currentax,tab,r,0);
                        IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8 0.8 0.8];
                        IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
                    else
                        IMAGEANLZ.(tab)(r).InitiateRedrawROI;
                        IMAGEANLZ.(tab)(r).UpdateStatus;
                        IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.BackgroundColor = [0.8,0.8,0.8];
                        IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.ForegroundColor = [0.149 0.149 0.241];
                        IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
                        IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
                        IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.6,0.2,0.2];
                        IMAGEANLZ.(tab)(r).FIGOBJS.RedrawROIbutton.ForegroundColor = [1 1 1];
                        Slice_Change(currentax,tab,r,0);
                    end
                end
            end
        end
    case 'Ortho'
        for r = 1:3
            Event = IMAGEANLZ.(tab)(r).ToggleROIRedrawEvent;
        end
        if strcmp(Event,'Add')
            IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.BackgroundColor = [0.8 0.8 0.8];
            IMAGEANLZ.(tab)(1).FIGOBJS.RedrawROIbutton.ForegroundColor = [0.149 0.149 0.241];
        elseif strcmp(Event,'Erase')
            for r = 1:1
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
end









