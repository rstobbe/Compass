%=================================
% LR1 - Standard Yarn-Ball
%       (v1c) - evolution alter 
%=================================

function dy = LR1_OutSol_v1c(t,y,deradsolfunc,sphi,stheta,p,SPIN)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*(r + SPIN.CentSpinFact*dr)*dr;
dtheta = stheta(r)*(1 + SPIN.CentSpinFact*dr/(2*r))*dr;

dy = [dr;dphi;dtheta];