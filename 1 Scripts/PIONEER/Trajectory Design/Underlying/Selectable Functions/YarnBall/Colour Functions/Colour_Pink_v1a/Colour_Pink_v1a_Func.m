%====================================================
%
%====================================================

function [CLR,err] = Colour_Pink_v1a_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';
CLR.ybcolourin = @PinkYarn_v1a;
CLR.ybcolourout = @PinkYarn_v1a;

%------------------------------------------
% Pink Yarn
%------------------------------------------
function dy = PinkYarn_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
CLR = INPUT.CLR;

r = y(1);
%phi = y(2);
%theta = y(3);

dr = p^2/(r^2*deradsolfunc(r));
dtheta = CLR.overspin*stheta(r)*pi*rad*dr;
dphi = sphi(r)*2*pi*rad*r*dtheta;

dy = [dr;dphi;dtheta];


