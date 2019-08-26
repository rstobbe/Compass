%====================================================
%
%====================================================

function [CLR,err] = Colour_Red_v1a_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';
CLR.ybcolourin = @RedYarn_v1a;
CLR.ybcolourout = @RedYarn_v1a;

%------------------------------------------
% Black Yarn
%------------------------------------------
function dy = RedYarn_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;

r = y(1);
%phi = y(2);
%theta = y(3);

dr = p^2/(r^2*deradsolfunc(r));
dtheta = stheta(r) * pi*rad*dr;
dphi = sphi(r) * (((2*pi*rad*r*dtheta)^2 + (rad*dr)^2 + (rad*r*dtheta)^2)^0.5);

dy = [dr;dphi;dtheta];


