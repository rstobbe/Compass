%=========================================================
% 
%=========================================================

function [IMP,err] = LR_Ideal_v2d_Func(INPUT)

Status('busy','Implement Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
IMP = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
SPIN = DES.SPIN;
DESOL = DES.DESOL;
CACC = DES.CACC;
PROJimp = INPUT.PROJimp;
NUC = INPUT.NUC;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
KSMP = INPUT.KSMP;
testingonly = INPUT.testingonly;
clear INPUT;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp.genprojfunc = PROJdgn.genprojfunc;
if not(exist(PROJimp.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(PROJimp.genprojfunc);

%------------------------------------------
% Visualization 
%------------------------------------------
SPIN.Vis = 'No'; 
KSMP.Vis = 'No';

%------------------------------------------
% Get LR spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([PROJdgn.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
TST.initstrght = 'No';
INPUT.TST = TST;
func = str2func([PROJdgn.desoltimfunc,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Projection Sampling
%------------------------------------------
if strcmp(testingonly,'Yes');
    PSMP.phi = pi/2;
    PSMP.theta = 0;
    Panel(1,:) = {'ndiscs','Testing','Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    PSMP.PanelOutput = PanelOutput;
else    
    INPUT.PROJdgn = PROJdgn;
    func = str2func([PROJimp.psmpmeth,'_Func']);           
    [PSMP,err] = func(PSMP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end
    
%---------------------------------------------
% Generate Trajectories
%---------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
TST.relprojlenmeas = 'No';
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
T = OUTPUT.T;
clear OUTPUT;
clear INPUT;

%------------------------------------------
% Assess Trajectory Speed 
%------------------------------------------
r = sqrt(KSA(1,:,1).^2 + KSA(1,:,2).^2 + KSA(1,:,3).^2);
PROJdgn.maxsmpdwellcenter = interp1(r,T,1/PROJdgn.rad);
figure(100); hold on;
plot(CACC.r,CACC.magvel0);
plot([PROJdgn.p PROJdgn.p],[0 10000],'k:');
xlim([0 1]);
ylim([0 10000]);
ind = find(CACC.r > 0.75,1,'first');
PROJdgn.maxsmpdwellouter = PROJdgn.kstep/mean(CACC.magvel0(ind:length(CACC.magvel0)));
PROJdgn.maxsmpdwell = PROJdgn.maxsmpdwellouter;

%----------------------------------------------------
% Get Nucleus Info
%----------------------------------------------------
func = str2func([PROJimp.nucfunc,'_Func']);
INPUT = [];
[NUC,err] = func(NUC,INPUT);
if err.flag
    return
end
PROJimp.nucleus = NUC.nucleus;
PROJimp.gamma = NUC.gamma;

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([PROJimp.tsmpmeth,'_Func']);  
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Sample k-Space
%----------------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TSMP = TSMP;
INPUT.KSA = KSA;
INPUT.T = T;
func = str2func([PROJimp.ksmpmeth,'_Func']);  
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
clear INPUT;
IMP.samp = KSMP.samp;
IMP.Kmat = KSMP.Kmat;
KSMP = rmfield(KSMP,'samp');
KSMP = rmfield(KSMP,'Kmat');

%---------------------------------------
% Consolidate PROJimp
%---------------------------------------
PROJimp.nproj = PROJdgn.nproj;
PROJimp.npro = TSMP.npro;
PROJimp.sampstart = TSMP.sampstart;
PROJimp.dwell = TSMP.dwell;
PROJimp.tro = TSMP.tro;
PROJimp.trajosamp = TSMP.trajosamp;
PROJimp.projosamp = PROJdgn.projosamp;
PROJimp.maxrelkmax = 1;
PROJimp.meanrelkmax = 1;

%---------------------------------------
% Output
%---------------------------------------
IMP.PROJimp = PROJimp;
IMP.PROJdgn = PROJdgn;
IMP.PSMP = PSMP;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);
