%=================================
% LR1 - Standard Yarn-Ball (within p)
%       (v1b) - evolution alter 
%=================================

function dy = LR1_InSol_v1b(t,y,deradsolfunc,sphi,stheta,p)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*(r + (1/(p^2*deradsolfunc(p))))*dr*((r/p)^2);                            % reducing the (r/p) power will reduce trajectory jerk (but increase looping - i.e. slightly slower)
dtheta = stheta(r)*(1 + (1/(p^2*deradsolfunc(p)))/(2*p))*dr*((r/p)^2);

dy = [dr;dphi;dtheta];