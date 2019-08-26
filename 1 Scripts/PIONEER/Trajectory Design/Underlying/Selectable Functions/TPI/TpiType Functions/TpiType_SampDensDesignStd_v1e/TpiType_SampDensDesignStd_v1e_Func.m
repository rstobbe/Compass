%====================================================
%
%====================================================

function [TPIT,err] = TpiType_SampDensDesignStd_v1e_Func(TPIT,INPUT)

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
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%----------------------------------------------------
% Get Radial Evolution Design Function
%----------------------------------------------------
Status2('busy','Get Gamma Design Function',3);
func = str2func([GAM.method,'_Func']);
INPUT.p = TPIT.p;
[GAM,err] = func(GAM,INPUT);
if err.flag ~= 0
    return
end
TPIT.RadDesFunc = GAM.GamFunc;

%----------------------------------------------------
% Save Gamma Shape and SDC Shape
%----------------------------------------------------
GAM.p = TPIT.p;
GAM.r = (0:0.0001:1);
GAM.GamShape = GAM.GamFunc(GAM.r,GAM.p);
if length(GAM.GamShape) == 1
    GAM.GamShape = ones(size(GAM.r))*GAM.GamShape;
end

%----------------------------------------------------
% Calculate Sampling Density
%----------------------------------------------------
SDpre = 1./(GAM.r(GAM.r<=GAM.p).^2);
SDpost = GAM.GamShape(GAM.r>GAM.p);
GAM.SampDensNoPos = [SDpre SDpost]*GAM.p;
TPIT.edgeSDnoPos = GAM.SampDensNoPos(end);

%----------------------------------------------------
% Calculate Sampling Timing
%----------------------------------------------------
func = str2func('TPI_SampTim_v1a');
GAM.projlen0 = 20;
GAM = func(GAM,PROJdgn);
TPIT.StdProjLen = GAM.projlen;
TPIT.StdInitRadEvRate = (PROJdgn.kmax*TPIT.p)/(PROJdgn.tro*TPIT.p/TPIT.StdProjLen);
TPIT.tatr = GAM.tatr;
TPIT.r = GAM.r;

%----------------------------------------------------
% Calculate Relative SNR
%----------------------------------------------------
func = str2func('SNR_Calc_v1b');
TPIT.rSNR = func(GAM,PROJdgn);

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
if isfield(GAM,'beta')
    sbeta = num2str(GAM.beta*10,'%2.0f');
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_B',sbeta];
elseif isfield(GAM,'N')
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_GH'];
else
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj];
end
    
%----------------------------------------------------
% Panel Items
%----------------------------------------------------
TPIT.Panel = GAM.Panel;
TPIT.GAM = GAM;

%====================================================
% SampDensTPI
%====================================================
function dy = TpiSampDensDesign_v1a(t,y,phi,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
TPIT = INPUT.TPIT;

r = y(1);
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));
    
v = sin(phi);  
w = (1-dr^2);
%---
if w < 0
    w = 0;                  % needed for inward solution
end
%---
dtheta = sqrt(w/(r^2*v^2));
dy = [dr;dtheta];

%====================================================
% RadEv
%====================================================
function dr = RadEv_v1a(t,r,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
TPIT = INPUT.TPIT;
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));



