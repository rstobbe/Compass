%====================================================
%
%====================================================

function [TPIT,err] = TpiType_CaSampDensDesign_v1d_Func(TPIT,INPUT)

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
INPUT.p1 = TPIT.p1;
INPUT.p2 = TPIT.p2;
[GAM,err] = func(GAM,INPUT);
if err.flag ~= 0
    return
end
TPIT.RadDesFunc = GAM.GamFunc;
TPIT.p = TPIT.p2;

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
%dr = 1;
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));

% if r < TPIT.p1
%     spinrate = 1;
% elseif r >= TPIT.p1 && r <= TPIT.p2
%     spinrate = (r/TPIT.p1)^2;
%     spinrate = 1;
% elseif r > TPIT.p2
%     spinrate = (TPIT.p2/TPIT.p1)^2;
% end
%spinrate = (TPIT.p2/TPIT.p1)^2;
spinrate = 100;

v = sin(phi);  
v = v*(2-r)^0.5;
w = (spinrate-dr^2);
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



