%====================================================
% 
%====================================================

function [DES,err] = TPI2a_v2i_Func(INPUT,DES)

Status('busy','Create Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GAMFUNC = DES.GAMFUNC;
clear INPUT;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DES.projlenfunc = 'TPI2_isegProjLen_v1c';
DES.samptimfunc = 'TPI_SampTim_v0a';
DES.rsnrfunc = 'SNR_Calc_v0b';
if not(exist(DES.projlenfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%----------------------------------------------------
% Basic Calcs
%----------------------------------------------------
PROJdgn.method = DES.method;
PROJdgn.fov = DES.fov;
PROJdgn.vox = DES.vox;
PROJdgn.tro = DES.tro;
PROJdgn.nproj = DES.nproj;
PROJdgn.elip = DES.elip;
PROJdgn.iseg = DES.iseg;
PROJdgn.kstep = 1000/PROJdgn.fov;                                          % k-space location step size
PROJdgn.kmax = 1000/(2*PROJdgn.vox);
PROJdgn.rad = PROJdgn.kmax/PROJdgn.kstep;

%----------------------------------------------------
% Get Gamma Design Function
%----------------------------------------------------
Status('busy','Get Gamma Design Function');
func = str2func([DES.gamfunc,'_Func']);
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
func = str2func(DES.projlenfunc);
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
func = str2func(DES.samptimfunc);
[tatr] = func(PROJdgn.r,PROJdgn.p,PROJdgn.tro,GamFunc,projlen);
PROJdgn.tatr = tatr;

%----------------------------------------------------
% Calculate Relative SNR
%----------------------------------------------------
func = str2func(DES.rsnrfunc);
rSNR = func(PROJdgn);
PROJdgn.rSNR = 0.1*rSNR/PROJdgn.elip;
PROJdgn.TrajType = 'TPI';

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Design',PROJdgn.method,'Output'};
Panel(2,:) = {'FoV',PROJdgn.fov,'Output'};
Panel(3,:) = {'Vox',PROJdgn.vox,'Output'};
Panel(4,:) = {'Tro',PROJdgn.tro,'Output'};
Panel(5,:) = {'Nprog',PROJdgn.nproj,'Output'};
Panel(6,:) = {'iSeg',PROJdgn.iseg,'Output'};
Panel(7,:) = {'Elip',PROJdgn.elip,'Output'};
PanelOutput1 = cell2struct(Panel,{'label','value','type'},2);
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'ProjOverSamp',PROJdgn.projosamp,'Output'};
Panel(3,:) = {'p',PROJdgn.p,'Output'};
Panel(4,:) = {'ProjLen',PROJdgn.projlen,'Output'};
Panel(5,:) = {'Gmax_est (mT/m)',PROJdgn.Gmax_est,'Output'};
Panel(6,:) = {'EdgeSD (no POS)',PROJdgn.edgeSDnoPOS,'Output'};
Panel(7,:) = {'RelSNR',PROJdgn.rSNR,'Output'};
PanelOutput2 = cell2struct(Panel,{'label','value','type'},2);
DES.PanelOutput = [PanelOutput1;GAMFUNC.PanelOutput;PanelOutput2];

%----------------------------------------------------
% Return
%----------------------------------------------------
DES.PROJdgn = PROJdgn;
GAMFUNC = rmfield(GAMFUNC,'GamFunc');                       % saving function handle causes warnings...
DES.GAMFUNC = GAMFUNC;

