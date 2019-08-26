%====================================================
%
%====================================================

function [TPIT,err] = TpiType_SampDensDesign_v1b_Func(TPIT,INPUT)

err.flag = 0;
err.msg = '';

TPIT.tpiin = @TpiSampDensDesign_v1a;
TPIT.tpiout = @TpiSampDensDesign_v1a;
TPIT.radevin = @RadEv_v1a;
TPIT.radevout = @RadEv_v1a;

%----------------------------------------------------
% Get Input
%----------------------------------------------------
GAM = TPIT.GAM;
clear INPUT;

%----------------------------------------------------
% Get Radial Evolution Design Function
%----------------------------------------------------
Status2('busy','Get Gamma Design Function',3);
func = str2func([GAM.method,'_Func']);
INPUT = struct();
[GAM,err] = func(GAM,INPUT);
if err.flag ~= 0
    return
end
TPIT.RadDesFunc = GAM.GamFunc;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Radial Evolution',TPIT.method,'Output'};
Panel = [Panel;GAM.Panel];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TPIT.PanelOutput = PanelOutput;
TPIT.Panel = Panel;

%====================================================
% SampDensTPI
%====================================================
function dy = TpiSampDensDesign_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
phi = INPUT.phi;
TPIT = INPUT.TPIT;
r = y(1);
%theta = y(2);
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));

if phi < pi/4
   phi = pi/4 - (0.6*((pi/4)-phi));
end
v = sin(phi);
    
v = v*(2-r)^0.5;
%v = v*(2-r)^(2.0*(1-v)+0.5);
%v = v*(2-r)^(1.5*(2-v));
%v = v*(2-r)^(1.5*(1-v));

w = (1-dr^2);
if w < 0.9
    w = 0.9;
end
dtheta = sqrt(w/(r^2*v^2));
dy = [dr;dtheta];

%====================================================
% RadEv
%====================================================
function dr = RadEv_v1a(t,r,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
TPIT = INPUT.TPIT;
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));



