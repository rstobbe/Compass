%=================================
% LR1 - Standard Yarn-Ball
%       (v1b) - evolution alter 
%=================================

function dy = LR1_OutSol_v1b(t,y,deradsolfunc,sphi,stheta,p)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*(r + dr)*dr;
dtheta = stheta(r)*(1 + dr/(2*r))*dr;

dy = [dr;dphi;dtheta];