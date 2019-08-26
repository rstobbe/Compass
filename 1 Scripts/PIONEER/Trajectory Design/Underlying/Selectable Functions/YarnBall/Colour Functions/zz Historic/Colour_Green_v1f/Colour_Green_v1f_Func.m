%====================================================
%
%====================================================

function [CLR,err] = Colour_Green_v1f_Func(CLR,INPUT)

err.flag = 0;
err.msg = '';

CLR.ybcolourin = @GreenYarnIn;
CLR.ybcolourout = @GreenYarnOut;
CLR.radevin = @RadEvIn;
CLR.radevout = @RadEvOut;

%====================================================
% Green Yarn In
%====================================================
function dy = GreenYarnIn(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
dir = INPUT.dir;
r = y(1);
dr = (p^2/r^2)*(1/deradsolfunc(r));
dtheta = dir*stheta(r)*pi*rad*dr;
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% Green Yarn Out
%====================================================
function dy = GreenYarnOut(t,y,INPUT)  

turnradfunc = INPUT.turnradfunc;
turnspinfunc = INPUT.turnspinfunc;
deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
dir = INPUT.dir;
r = y(1);
if r > 1  
    dr = dir*turnradfunc(p,r)*(1/deradsolfunc(r));    
    dr0 = dir*turnspinfunc(p,r)*(1/deradsolfunc(r));   
    %dr0 = dir*(p^2/r^2)*(1/deradsolfunc(r));
else
    dr = dir*(p^2/r^2)*(1/deradsolfunc(r));
    dr0 = dir*dr;
end
dtheta = stheta(r)*pi*rad*abs(dr0);
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% RadEvIn
%====================================================
function dr = RadEvIn(t,r,INPUT) 

deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
dr = (p^2/r^2)*(1/deradsolfunc(r));   

%====================================================
% RadEvOut
%====================================================
function dr = RadEvOut(t,r,INPUT) 

turnradfunc = INPUT.turnradfunc;
deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
if r > 1
    dr = turnradfunc(p,r)*(1/deradsolfunc(r));   
else
    dr = (p^2/r^2)*(1/deradsolfunc(r));
end

