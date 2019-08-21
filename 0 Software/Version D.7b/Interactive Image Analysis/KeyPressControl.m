%============================================
% What to do key pressed
%============================================
function KeyPressControl(currentax,tab,axnum,event)

global IMAGEANLZ

GETROIS = IMAGEANLZ.(tab)(axnum).GETROIS;
GETLINE = IMAGEANLZ.(tab)(axnum).GETLINE;

switch event.Character  
    case 'z'                                        % New current ROI
        if GETROIS == 1
            return
        end       
        NewROI(tab,axnum);
        set(gcf,'pointer',IMAGEANLZ.(tab)(axnum).pointer);
    case 'x'                                        % Delete last drawing
        if GETROIS == 0
            return
        end
        DeleteLastRegion(tab,axnum);
    case 'c'                                        % Complete current ROI / save
        if GETROIS == 0
            return
        end
        CompleteCurrentROI(tab,axnum);
    case 'v'                                        % Complete current ROI / don't save
        if GETROIS == 0
            return
        end
        DiscardCurrentROI(tab,axnum);      
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
%     case 's'
%         IMAGEANLZ.(tab)(axnum).ClearROIPanel;
%         ROISETUP = IMAGEANLZ.(tab)(axnum).ROISEED.Setup(IMAGEANLZ.(tab)(axnum)); 
%         IMAGEANLZ.(tab)(axnum).SetupROI(ROISETUP);
%         RWSUIGBL.Key = '';
%         RWSUIGBL.Character = '';
%     case 'S'
%         if GETROIS == 0
%             Status('error','No current ROI active');
%             return
%         end
%         ROI_Seeded_N(tab,axnum);
%     case 'f'
%         if GETROIS == 0
%             return
%         end
%     case 'o'
%         IMAGEANLZ.(tab)(axnum).ClearROIPanel;
%         ROISETUP = IMAGEANLZ.(tab)(axnum).ROISPHERE.Setup(IMAGEANLZ.(tab)(axnum)); 
%         IMAGEANLZ.(tab)(axnum).SetupROI(ROISETUP);
%     case 'p'
%         PlotMontage(tab,axnum);
     case 'l'
        if GETROIS == 1
            return
        end  
%         if GETLINE == 1
%             return
%         end  
        NewLine(tab,axnum);
%     case 'g'
%         %Show_All_ROIs;
%     case 'h'
%         %Hide_All_ROIs;
    case 'Q'
        TabReset(tab);  
    case 'U'
        AxisReset(tab,axnum);         
end
