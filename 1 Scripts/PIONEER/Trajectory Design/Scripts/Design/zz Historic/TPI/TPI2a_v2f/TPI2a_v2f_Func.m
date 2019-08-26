%====================================================
% 
%====================================================

function [DES,err] = TPI2a_v2f_Func(INPUT)

Status('busy','Create Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
DES = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
GAMFUNC = INPUT.GAMFUNC;
clear INPUT;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJdgn.projlenfunc = 'TPI2_isegProjLen_v1b';
PROJdgn.samptimfunc = 'TPI_SampTim_v1a';
PROJdgn.rsnrfunc = 'SNR_Calc_v1b';
if not(exist(PROJdgn.projlenfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%----------------------------------------------------
% Basic Calcs
%----------------------------------------------------
PROJdgn.kstep = 1000/PROJdgn.fov;                                          % k-space location step size
PROJdgn.kmax = 1000/(2*PROJdgn.vox);
PROJdgn.rad = PROJdgn.kmax/PROJdgn.kstep;

%----------------------------------------------------
% Get Gamma Design Function
%----------------------------------------------------
Status('busy','Get Gamma Design Function');
func = str2func([PROJdgn.gamfunc,'_Func']);
INPUT = struct();
[GAMFUNC,err] = func(GAMFUNC,INPUT);
if err.flag ~= 0
    return
end
GamFunc = GAMFUNC.GamFunc;

%----------------------------------------------------
% Calculate Relative Projection Length
%----------------------------------------------------
Status('busy','Calculate Relative Projection Length');
pinit = 0.15;
func = str2func(PROJdgn.projlenfunc);
[projlen,p] = func(PROJdgn.iseg,GamFunc,PROJdgn.tro,pinit); 
PROJdgn.p = p;
PROJdgn.projlen = projlen;

%----------------------------------------------------
% Calculate Projection Oversampling
%----------------------------------------------------
thnproj = round((4*pi*(PROJdgn.rad)^2)*PROJdgn.p);
PROJdgn.projosamp = PROJdgn.nproj/thnproj;

%----------------------------------------------------
% Save Gamma Shape and SDC Shape
%----------------------------------------------------
GAMFUNC.p = PROJdgn.p;
GAMFUNC.r = (0:0.001:1);
GAMFUNC.GamShape = GamFunc(GAMFUNC.r,GAMFUNC.p);
if length(GAMFUNC.GamShape) == 1
    GAMFUNC.GamShape = ones(size(GAMFUNC.r))*GAMFUNC.GamShape;
end
PROJdgn.r = GAMFUNC.r;
PROJdgn.GamShape = GAMFUNC.GamShape;
PROJdgn.sdcR = GAMFUNC.r;
PROJdgn.sdcTF = GAMFUNC.GamShape*p;

%----------------------------------------------------
% Calculate Sampling Density
%----------------------------------------------------
SDpre = 1./(PROJdgn.r(PROJdgn.r<=p).^2);
SDpost = PROJdgn.GamShape(PROJdgn.r>p);
PROJdgn.SampDens = [SDpre SDpost]*p*PROJdgn.projosamp;
PROJdgn.edgeSD = PROJdgn.SampDens(length(PROJdgn.SampDens));
PROJdgn.edgeSDnoPOS = PROJdgn.SampDens(length(PROJdgn.SampDens))/PROJdgn.projosamp;

%----------------------------------------------------
% Calculate Noise Power Spectral Density
%----------------------------------------------------
PSDpre = (PROJdgn.kmax^3*PROJdgn.projlen/(PROJdgn.tro*PROJdgn.GamShape(1)^2))*((PROJdgn.GamShape(PROJdgn.r<=p).^2).*(PROJdgn.r(PROJdgn.r<=p).^2));
PSDpost = (PROJdgn.kmax^3*PROJdgn.projlen/(PROJdgn.tro*PROJdgn.GamShape(1)^2))*PROJdgn.GamShape(PROJdgn.r>p);
PROJdgn.PSD = [PSDpre PSDpost];

%----------------------------------------------------
% Gradient and SNR estimations
%----------------------------------------------------
%rSNR_est = 0.01*PROJdgn.vox^3*PROJdgn.GamShape(1)*sqrt(PROJdgn.tro)/PROJdgn.projlen;
%rGradConst = (PROJdgn.GamShape(1)^(1/3))*(PROJdgn.projlen^(2/3))/(PROJdgn.tro^(5/6))
PROJdgn.Gmax_est = 1000*PROJdgn.p/(2*PROJdgn.iseg*PROJdgn.vox*11.26);
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Gmax (mT/m)','0output',PROJdgn.p/(2*PROJdgn.iseg*PROJdgn.vox*11.26),'0numout');

%----------------------------------------------------
% Calculate Sampling Timing
%----------------------------------------------------
func = str2func(PROJdgn.samptimfunc);
[tatr] = func(PROJdgn.r,PROJdgn.p,PROJdgn.tro,GamFunc,projlen);
PROJdgn.tatr = tatr;

%----------------------------------------------------
% Calculate Relative SNR
%----------------------------------------------------
func = str2func(PROJdgn.rsnrfunc);
rSNR = func(PROJdgn);
PROJdgn.rSNR = 0.1*rSNR/PROJdgn.elip;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'ProjOverSamp',PROJdgn.projosamp,'Output'};
Panel(2,:) = {'p',PROJdgn.p,'Output'};
Panel(3,:) = {'ProjLen',PROJdgn.projlen,'Output'};
Panel(4,:) = {'Gmax_est (mT/m)',PROJdgn.Gmax_est,'Output'};
Panel(5,:) = {'EdgeSD (no POS)',PROJdgn.edgeSDnoPOS,'Output'};
Panel(6,:) = {'RelSNR',PROJdgn.rSNR,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DES.PanelOutput = PanelOutput;

%----------------------------------------------------
% Return
%----------------------------------------------------
DES.PROJdgn = PROJdgn;
GAMFUNC = rmfield(GAMFUNC,'GamFunc');                       % saving function handle causes warnings...
DES.GAMFUNC = GAMFUNC;

