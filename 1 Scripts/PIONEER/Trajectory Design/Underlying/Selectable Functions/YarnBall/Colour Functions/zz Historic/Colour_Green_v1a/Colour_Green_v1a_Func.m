%====================================================
%
%====================================================

function [CLR,err] = Colour_Green_v1a_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';
CLR.ybcolourin = @GreenYarn_v1a;
CLR.ybcolourout = @GreenYarn_v1a;

%------------------------------------------
% Green Yarn
%------------------------------------------
function dy = GreenYarn_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;

r = y(1);
%phi = y(2);
%theta = y(3);

dr = p^2/(r^2*deradsolfunc(r));
dtheta = stheta(r)*pi*rad*dr;
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;


dy = [dr;dphi;dtheta];


