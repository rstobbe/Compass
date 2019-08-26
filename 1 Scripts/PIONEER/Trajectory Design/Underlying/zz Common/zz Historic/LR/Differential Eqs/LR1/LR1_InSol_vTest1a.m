%=================================
% LR1 - Standard Yarn-Ball (within p)
%
%=================================

function dy = LR1_InSol_vTest1a(t,y,deradsolfunc,sphi,stheta,p,SPIN)  

r = y(1);
%phi = y(2);
%theta = y(3);

dr = 1/(r^2*deradsolfunc(r));
dtheta = stheta(r)*dr;

dratp = (round(1e9/(p^2*deradsolfunc(p))))/1e9;
if dratp ~= 1
    error
end
%dphi = sphi(r)*(r + SPIN.CentSpinFact*dratp)*dtheta;

%dphi = sphi(r)*(r + ((r/p)^SPIN.SpawnFact)*SPIN.CentSpinFact)*dtheta;
%dphi = sphi(r)*(r + (r/p)^(1/SPIN.SpawnFact)*SPIN.CentSpinFact)*dtheta;
%dphi = sphi(r)*(r)*dtheta;
%dphi = sphi(r)*(r + SPIN.CentSpinFact)*dtheta;
%dphi = sphi(r)*(r + SPIN.CentSpinFact)*dtheta * (r/p)^(2/SPIN.SpawnFact);

%dphi = sphi(r) * sqrt((r*dtheta)^2 + dr^2);
dphi = sphi(r) * (r*dtheta);


dy = [dr;dphi;dtheta];