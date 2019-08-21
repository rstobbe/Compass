%============================================
% Draw all ROIS
%============================================
function Draw_Line

global LINE
global AX1
global AX2
global TOGLINE
global IMT

if not(strcmp(TOGLINE,'on'))
    return
end
  
for r = 1:2    
    if not(isempty(IMT{r}))
        switch r
            case 1; axes = AX1;
            case 2; axes = AX2;
        end
        %line([LINE(1).x LINE(2).x],[LINE(1).y LINE(2).y],'parent',axes,'linewidth',1,'color','r');
        line([LINE(1).x LINE(2).x],[LINE(1).y LINE(2).y],'parent',axes,'color','r');
        Plot_Line_Marker(LINE(1).x,LINE(1).y);
        Plot_Line_Marker2(LINE(2).x,LINE(2).y);
    end
end



