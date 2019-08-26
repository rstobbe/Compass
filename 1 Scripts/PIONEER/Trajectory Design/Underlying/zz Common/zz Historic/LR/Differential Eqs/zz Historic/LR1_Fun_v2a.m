%=================================
% Yarn-Ball (no theta speed dependence)
%=================================

function dy = LR1_Fun_v2a(t,y,flag,RADEVFUN,sphi,stheta)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*RADEVFUN(r));
dphi = sphi(r)*dr*r;
dtheta = stheta(r)*dr;

dy = [dr;dphi;dtheta];