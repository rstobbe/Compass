%============================================
% AndROI
%============================================
function AndROI(tab,axnum)

global IMAGEANLZ

if not(IMAGEANLZ.(tab)(axnum).TestFinishedCurrentROI) 
    Status2('warn','No ROI to And',3);
    return
end
if IMAGEANLZ.(tab)(axnum).redrawroi == 1
    return
end
if IMAGEANLZ.(tab)(axnum).TestEmptyCurrentROI
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
                Event = IMAGEANLZ.(tab)(r).ToggleROIAndEvent;
                if strcmp(Event,'Add')
                    IMAGEANLZ.(tab)(r).ReturnAndROI;
                    IMAGEANLZ.(tab)(r).UpdateStatus;
                    Slice_Change(currentax,tab,r,0);
                    IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.BackgroundColor = [0.8 0.8 0.8];
                    IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.ForegroundColor = [0.149 0.149 0.241];
                elseif strcmp(Event,'And')
                    IMAGEANLZ.(tab)(r).InitiateAndROI;
                    IMAGEANLZ.(tab)(r).UpdateStatus;
                    Slice_Change(currentax,tab,r,0);
                    IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.BackgroundColor = [0.6,0.2,0.2];
                    IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.ForegroundColor = [1 1 1];
                    IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
                    IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
                end
            end
        end
    case 'Ortho'
        for r = 1:1
            IMAGEANLZ.(tab)(r).InitiateAndROI;
            IMAGEANLZ.(tab)(r).UpdateStatus;
        end
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8,0.8,0.8];
        IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
        IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.BackgroundColor = [0.6,0.2,0.2];
        IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.ForegroundColor = [1 1 1];
        Slice_Change(currentax,tab,1,0);
end


% 
% 
% global IMAGEANLZ
% if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
%     error;          % shouldn't get here
% end
% if IMAGEANLZ.(tab)(axnum).GETROIS == 0
%     error;          % shouldn't get here
% end
% 
% 
% switch IMAGEANLZ.(tab)(axnum).presentation
%     case 'Standard'
%         if IMAGEANLZ.(tab)(axnum).ROITIE == 1
%             start = 1;    
%             stop = IMAGEANLZ.(tab)(1).axeslen;
%         else
%             start = axnum;
%             stop = axnum;
%         end
%         for r = start:stop
%             if IMAGEANLZ.(tab)(r).TestAxisActive
%                 Event = IMAGEANLZ.(tab)(r).ToggleROIAndEvent;
%                 if strcmp(Event,'Add')
%                     IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.BackgroundColor = [0.8 0.8 0.8];
%                     IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.ForegroundColor = [0.149 0.149 0.241];
%                 elseif strcmp(Event,'And')
%                     IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.BackgroundColor = [0.6,0.2,0.2];
%                     IMAGEANLZ.(tab)(r).FIGOBJS.AndROIbutton.ForegroundColor = [1 1 1];
%                     IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
%                     IMAGEANLZ.(tab)(r).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
%                 end
%             end
%         end
%     case 'Ortho'
%         for r = 1:3
%             Event = IMAGEANLZ.(tab)(r).ToggleROIAndEvent;
%         end
%         if strcmp(Event,'Add')
%             IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.BackgroundColor = [0.8 0.8 0.8];
%             IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.ForegroundColor = [0.149 0.149 0.241];
%         elseif strcmp(Event,'And')
%             IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.BackgroundColor = [0.6,0.2,0.2];
%             IMAGEANLZ.(tab)(1).FIGOBJS.AndROIbutton.ForegroundColor = [1 1 1];
%             IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.BackgroundColor = [0.8 0.8 0.8];
%             IMAGEANLZ.(tab)(1).FIGOBJS.EraseROIbutton.ForegroundColor = [0.149 0.149 0.241];
%         end
% end
%         


