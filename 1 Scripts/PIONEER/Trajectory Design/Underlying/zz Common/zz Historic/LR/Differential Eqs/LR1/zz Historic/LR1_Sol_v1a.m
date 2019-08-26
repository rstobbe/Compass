%=================================
% LR1 (Yarn-Ball)
%       - no theta speed dependence
%=================================

function dy = LR1_Sol_v1a(t,y,deradsolfunc,sphi,stheta)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*dr*r;
dtheta = stheta(r)*dr;

dy = [dr;dphi;dtheta];