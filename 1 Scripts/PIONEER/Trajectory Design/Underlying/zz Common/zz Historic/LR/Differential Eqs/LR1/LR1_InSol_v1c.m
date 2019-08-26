%=================================
% LR1 - Standard Yarn-Ball (within p)
%       (v1c) - evolution alter 
%=================================

function dy = LR1_InSol_v1c(t,y,deradsolfunc,sphi,stheta,p,SPIN)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*(r + (SPIN.CentSpinFact/(p^2*deradsolfunc(p))))*dr*((r/p)^(2/SPIN.SpawnFact));                            % reducing the (r/p) power will reduce trajectory jerk (but increase looping - i.e. slightly slower)
dtheta = stheta(r)*(1 + (SPIN.CentSpinFact/(p^2*deradsolfunc(p)))/(2*p))*dr*((r/p)^(2/SPIN.SpawnFact));

dy = [dr;dphi;dtheta];