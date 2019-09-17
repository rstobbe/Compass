%============================================
% What to do key pressed
%============================================
function KeyPressControl(currentax,tab,axnum,event)

global IMAGEANLZ

GETROIS = IMAGEANLZ.(tab)(axnum).GETROIS;
LineToolActive = IMAGEANLZ.(tab)(axnum).LineToolActive;

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    return
end

switch event.Character  
    case 'z'                                        % New current ROI
        if GETROIS == 1 || LineToolActive == 1
            return
        end       
        NewROI(tab,axnum);
        set(gcf,'pointer',IMAGEANLZ.(tab)(axnum).pointer);
    case 'x'                                        % Delete last drawing
        if GETROIS == 0
            return
        end
        DeleteLastRegion(tab,axnum);
    case 'e'                                        % Toggle Erase Function
        if GETROIS == 0
            return
        end
        EraseROI(tab,axnum);
    case 's'                                        % Toggle Shading
        ToggleShadeROI(tab,axnum);
    case 'd'                                        % Toggle ROI Line Drawing
        ToggleLinesROI(tab,axnum);
    case 'c'                                        % Complete current ROI / save
        if GETROIS == 0
            return
        end
        CompleteCurrentROI(tab,axnum);
    case 'v'                                        % Complete current ROI / don't save
        if GETROIS == 1
            DiscardCurrentROI(tab,axnum); 
        elseif LineToolActive == 1
            EndLineTool(tab,axnum);
        else
            return
        end  
    case 'b'                                        % Complete current ROI / don't save
        if GETROIS == 0
            return
        end
        UpdateTempValues(tab,axnum);
        UpdateCurrentValues(tab,axnum);  
    case 'j'  
        if GETROIS == 0
            return
        end
        NudgeLeft(tab,axnum); 
    case 'k'  
        if GETROIS == 0
            return
        end
        NudgeRight(tab,axnum); 
    case 'i'  
        if GETROIS == 0
            return
        end
        NudgeUp(tab,axnum); 
    case 'm'  
        if GETROIS == 0
            return
        end
        NudgeDown(tab,axnum);
    case ','  
        if GETROIS == 0
            return
        end
        NudgeIn(tab,axnum); 
    case '.'  
        if GETROIS == 0
            return
        end
        NudgeOut(tab,axnum); 
     case 'l'
        if GETROIS == 1
            return
        end  
        if LineToolActive == 1
            return
        end  
        NewLine(tab,axnum);
%     case 'g'
%         %Show_All_ROIs;
%     case 'h'
%         %Hide_All_ROIs;
    case 'Q'
        TabReset(tab);  
%     case 'U'
%         AxisReset(tab,axnum);         
end
