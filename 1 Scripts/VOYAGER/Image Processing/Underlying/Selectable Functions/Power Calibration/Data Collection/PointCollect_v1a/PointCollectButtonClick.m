%=========================================================
% 
%=========================================================

function PointCollectButtonClick(src,event)

global glbDATCOL
values = glbDATCOL.values;
Im = glbDATCOL.Im;

pt = get(gca,'CurrentPoint');
x = pt(1,1);
y = pt(1,2);

%---------------------------------------------
% Test
%---------------------------------------------
sz = size(Im);
if x > sz(2)
    return
elseif x < 0
    return
elseif y > sz(1)
    return
elseif y < 0
    return
end

%---------------------------------------------
% Get Value
%---------------------------------------------
val = Im(round(y),round(x));
glbDATCOL.values = [values val];

%---------------------------------------------
% Plot 'X'
%---------------------------------------------
line([x-1 x+1],[y-1 y+1],'parent',gca,'color','r','linewidth',2);
line([x-1 x+1],[y+1 y-1],'parent',gca,'color','r','linewidth',2);
drawnow;

