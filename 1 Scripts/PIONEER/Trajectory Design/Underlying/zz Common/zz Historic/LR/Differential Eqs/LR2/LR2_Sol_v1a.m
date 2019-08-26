%=================================================
% LR2 (Anistropic FoV Yarn-Ball)
%    - faster x / slower y / same z
%    - relative increase/decrease in 'reltheta'
%=================================================

function dy = LR2_Sol_v1a(t,y,deradsolfunc,sphi,stheta,reltheta)  

r = y(1);
phi = y(2);
theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dphi = sphi(r)*dr*r;
dtheta = stheta(r)*dr*(reltheta^(cos(2*theta)));

dy = [dr;dphi;dtheta];