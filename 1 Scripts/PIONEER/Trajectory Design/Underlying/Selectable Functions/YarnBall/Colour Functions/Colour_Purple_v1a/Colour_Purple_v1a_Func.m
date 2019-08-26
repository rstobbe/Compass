%====================================================
%
%====================================================

function [CLR,err] = Colour_Purple_v1a_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';
CLR.ybcolourin = @PurpleYarnIn_v1a;
CLR.ybcolourout = @PurpleYarnOut_v1a;

%------------------------------------------
% Purple Yarn In
%------------------------------------------
function dy = PurpleYarnIn_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
CLR = INPUT.CLR;

r = y(1);
dr = p^2/(r^2*deradsolfunc(r));
dtheta0 = stheta(r)*pi*rad*dr;
%dtheta = dtheta0*(1 + CLR.centrespinfact*dr/(2*r));
%dtheta = dtheta0*(1 + CLR.centrespinfact/(2*p*deradsolfunc(p)));
dtheta = dtheta0*(1 + CLR.centrespinfact/(2*p*deradsolfunc(p)))*((r/p)^(2/CLR.spawnfact));
dphi0 = sphi(r)*2*pi*rad*dtheta0;
%dphi = dphi0*(r + CLR.centrespinfact*dr);
%dphi = dphi0*(r + CLR.centrespinfact/deradsolfunc(p));  
dphi = dphi0*(r + CLR.centrespinfact/deradsolfunc(p))*((r/p)^(2/CLR.spawnfact));  
dy = [dr;dphi;dtheta];

%------------------------------------------
% Purple Yarn Out
%------------------------------------------
function dy = PurpleYarnOut_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
CLR = INPUT.CLR;

r = y(1);
dr = p^2/(r^2*deradsolfunc(r));
dtheta0 = stheta(r)*pi*rad*dr;
dtheta = dtheta0*(1 + CLR.centrespinfact*dr/(2*r));
dphi0 = sphi(r)*2*pi*rad*dtheta0;
dphi = dphi0*(r + CLR.centrespinfact*dr);
dy = [dr;dphi;dtheta];

