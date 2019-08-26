%====================================================
%
%====================================================

function [CLR,err] = Colour_GreenIO_v1b_Func(CLR,INPUT)

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
r = y(1);
dr = p^2/(r^2*deradsolfunc(r));
dtheta = stheta(r)*pi*rad*dr;
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% Green Yarn Out
%====================================================
function dy = GreenYarnOut(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
sphi = INPUT.sphi;
stheta = INPUT.stheta;
p = INPUT.p;
rad = INPUT.rad;
r = y(1);
if r > 1  
    if not(isfield(INPUT,'radslowfact'))
        radslowfact = 1;
        spinslowfact = 1;
    else
        radslowfact = INPUT.radslowfact;
        spinslowfact = INPUT.spinslowfact;
    end
    dr = p^2/(r^(2*r^radslowfact)*deradsolfunc(r));
    dr0 = p^2/(r^(2*r^spinslowfact)*deradsolfunc(r));
else
    dr = p^2/(r^2*deradsolfunc(r));
    dr0 = dr;
end
dtheta = stheta(r)*pi*rad*dr0;
dphi = 2*(sphi(r)*pi*rad*r + 0.5)*dtheta;
dy = [dr;dphi;dtheta];

%====================================================
% RadEvIn
%====================================================
function dr = RadEvIn(t,r,INPUT) 

deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
dr = p^2/(r^2*deradsolfunc(r));    

%====================================================
% RadEvOut
%====================================================
function dr = RadEvOut(t,r,INPUT) 

deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
if r > 1
    if not(isfield(INPUT,'radslowfact'))
        radslowfact = 1;
    else
        radslowfact = INPUT.radslowfact;
    end    
    dr = p^2/(r^(2*radslowfact)*deradsolfunc(r));
else
    dr = p^2/(r^2*deradsolfunc(r));
end


