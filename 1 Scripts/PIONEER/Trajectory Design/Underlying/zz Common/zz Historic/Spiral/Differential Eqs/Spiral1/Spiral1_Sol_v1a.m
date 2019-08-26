%=================================
% Spiral1 
%       
%=================================

function dy = Spiral1_Sol_v1a(t,y,deradsolfunc,stheta)  

r = y(1);
theta = y(2);

dr = 1/(r*deradsolfunc(r));
dtheta = stheta(r)*dr;

dy = [dr;dtheta];