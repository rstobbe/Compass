%====================================================
%
%====================================================

function [CLR,err] = Colour_Green_v1b_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';

CLR.ybcolourin = @GreenYarn;
CLR.ybcolourout = @GreenYarn;
CLR.radevin = @RadEv;
CLR.radevout = @RadEv;

%====================================================
% Green Yarn (full)
%====================================================
function dy = GreenYarn(t,y,INPUT)  

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


%====================================================
% RadEv
%====================================================
function dr = RadEv(t,r,INPUT) 

deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
dr = p^2/(r^2*deradsolfunc(r));    