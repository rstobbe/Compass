%===================================================
% Plot Line Marker
%===================================================
function Plot_Line_Marker2(x,y)

global AX1
global AX2
global SCALE
global IMT
global IMDIM
global LINEMARKHAND2

symax = SCALE.ymax;
symin = SCALE.ymin;        
sxmax = SCALE.xmax;
sxmin = SCALE.xmin;  
yscale = (symax-symin+1);
xscale = (sxmax-sxmin+1);
 
for r = 1:2    
    if isempty(IMT{r})
    else
        switch r
            case 1; axes = AX1;
            case 2; axes = AX2;
        end
        %x1 = x-0.15*xscale/IMDIM.x2;
        %x2 = x+0.15*xscale/IMDIM.x2;
        %y1 = y-0.15*yscale/IMDIM.y2;
        %y2 = y+0.15*yscale/IMDIM.y2;
        x1 = x-0.0035*xscale;
        x2 = x+0.0035*xscale;
        y1 = y-0.0035*xscale;
        y2 = y+0.0035*xscale;
        LINEMARKHAND2(r,1) = line([x1 x2],[y1 y1],'parent',axes,'linewidth',1,'color','r');
        LINEMARKHAND2(r,2) = line([x1 x2],[y2 y2],'parent',axes,'linewidth',1,'color','r');
        LINEMARKHAND2(r,3) = line([x1 x1],[y1 y2],'parent',axes,'linewidth',1,'color','r');
        LINEMARKHAND2(r,4) = line([x2 x2],[y1 y2],'parent',axes,'linewidth',1,'color','r');
    end
end


