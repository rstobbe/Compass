%=================================
% LR1 - Standard Yarn-Ball
%      
%=================================

function dy = LR1_OutSol_vTest1a(t,y,deradsolfunc,sphi,stheta,p,SPIN)  

r = y(1);
%phi = y(2);
%theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dtheta = stheta(r)*dr;
%dphi = sphi(r)*(r + SPIN.CentSpinFact*dr)*dtheta;

%dphi = sphi(r) * sqrt((r*dtheta)^2 + dr^2);
dphi = sphi(r) * (r*dtheta);

dy = [dr;dphi;dtheta];