%====================================================
%
%====================================================

function [RADDES,err] = RadDes_TpiSampDensDesign_v1a_Func(RADDES,INPUT)

err.flag = 0;
err.msg = '';

RADDES.tpiin = @TpiSampDensDesign_v1a;
RADDES.tpiout = @TpiSampDensDesign_v1a;
RADDES.radevin = @RadEv_v1a;
RADDES.radevout = @RadEv_v1a;

%----------------------------------------------------
% Get Input
%----------------------------------------------------
GAM = RADDES.GAM;
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
RADDES.RadDesFunc = GAM.GamFunc;

% %----------------------------------------------------
% % Save Gamma Shape and SDC Shape
% %----------------------------------------------------
% GAMFUNC.p = PROJdgn.p;
% GAMFUNC.r = (0:0.001:1);
% GAMFUNC.GamShape = GamFunc(GAMFUNC.r,GAMFUNC.p);
% if length(GAMFUNC.GamShape) == 1
%     GAMFUNC.GamShape = ones(size(GAMFUNC.r))*GAMFUNC.GamShape;
% end
% PROJdgn.r = GAMFUNC.r;
% PROJdgn.GamShape = GAMFUNC.GamShape;
% PROJdgn.sdcR = GAMFUNC.r;
% PROJdgn.sdcTF = GAMFUNC.GamShape*p;
% 
% %----------------------------------------------------
% % Calculate Sampling Density
% %----------------------------------------------------
% SDpre = 1./(PROJdgn.r(PROJdgn.r<=p).^2);
% SDpost = PROJdgn.GamShape(PROJdgn.r>p);
% PROJdgn.SampDens = [SDpre SDpost]*p*PROJdgn.projosamp;
% PROJdgn.edgeSD = PROJdgn.SampDens(length(PROJdgn.SampDens));
% PROJdgn.edgeSDnoPOS = PROJdgn.SampDens(length(PROJdgn.SampDens))/PROJdgn.projosamp;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Radial Evolution',RADDES.method,'Output'};
Panel = [Panel;GAM.Panel];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RADDES.PanelOutput = PanelOutput;
RADDES.Panel = Panel;

%====================================================
% SampDensTPI
%====================================================
function dy = TpiSampDensDesign_v1a(t,y,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
phi = INPUT.phi;
RADDES = INPUT.RADDES;
r = y(1);
%theta = y(2);
dr = 1/(r^2*deradsolfunc(r)*RADDES.RadDesFunc(r,RADDES.p));
dtheta = sqrt((1-r^2)/(r^2*(sin(phi))^2));
dy = [dr;dtheta];

%====================================================
% RadEv
%====================================================
function dr = RadEv_v1a(t,r,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
RADDES = INPUT.RADDES;
dr = 1/(r^2*deradsolfunc(r)*RADDES.RadDesFunc(r,RADDES.p));



