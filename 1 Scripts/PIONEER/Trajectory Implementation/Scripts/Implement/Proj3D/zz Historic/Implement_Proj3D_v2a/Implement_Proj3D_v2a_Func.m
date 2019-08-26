%=========================================================
% 
%=========================================================

function [IMP,err] = Implement_Proj3D_v2a_Func(INPUT,IMP)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
TST = INPUT.TST;
NUC = INPUT.NUC;
SYS = INPUT.SYS;
IMETH = INPUT.IMETH;
clear INPUT;

%----------------------------------------------------
% Get Testing Info
%----------------------------------------------------
Status('busy','Get Testing Info');
func = str2func([IMP.testfunc,'_Func']);
INPUT = [];
[TST,err] = func(TST,INPUT);
if err.flag
    return
end

%----------------------------------------------------
% Get System Info
%----------------------------------------------------
Status('busy','Get System Info');
func = str2func([IMP.sysfunc,'_Func']);
INPUT = [];
[SYS,err] = func(SYS,INPUT);
if err.flag
    return
end
PROJimp.system = SYS.System;

%----------------------------------------------------
% Get Nucleus Info
%----------------------------------------------------
Status('busy','Get Nucleus Info');
func = str2func([IMP.nucfunc,'_Func']);
INPUT = [];
[NUC,err] = func(NUC,INPUT);
if err.flag
    return
end
PROJimp.nucleus = NUC.nucleus;
PROJimp.gamma = NUC.gamma;

%----------------------------------------------------
% Define Projection Sampling
%----------------------------------------------------
Status('busy','Define Projection Sampling');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;  
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'DefProjSamp';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp = IMETH.PROJimp;

%----------------------------------------------------
% Test/Modify Design
%----------------------------------------------------
Status('busy','Test/Tweak Design for Implementation');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'TestTweak';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
impPROJdgn = IMETH.impPROJdgn;
PROJimp = IMETH.PROJimp;

%----------------------------------------------------
% Generate Projections
%----------------------------------------------------
Status('busy','Generate Trajectories');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
%INPUT.impPROJdgn = impPROJdgn;
INPUT.mode = 'GenDes';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp = IMETH.PROJimp;

%----------------------------------------------------
% Create Gradient Waveforms
%----------------------------------------------------
Status('busy','Create Gradient Waveforms');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'Build';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp = IMETH.PROJimp;

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
Status('busy','Define Trajectory Sampling');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'TrajSamp';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp = IMETH.PROJimp;

%---------------------------------------
% Resample k-Space
%---------------------------------------
Status('busy','Resample k-Space');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'Recon';
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT
KSMP = IMETH.KSMP;
G = IMETH.Gscnr;
qTscnr = IMETH.qTscnr;
IMETH = rmfield(IMETH,{'KSMP','Gscnr','qTscnr'});
samp = KSMP.samp;
Kmat = KSMP.Kmat;
Kend = KSMP.Kend;
KSMP = rmfield(KSMP,{'samp' 'Kmat' 'Kend'});
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;
PROJimp.npro = KSMP.nproRecon;

%----------------------------------------------------
% Add Design to Panel Output
%----------------------------------------------------
Panel(1,:) = {'FovDim (mm)',impPROJdgn.fov,'Output'};
Panel(2,:) = {'VoxDim (mm)',impPROJdgn.vox,'Output'};
Panel(3,:) = {'Elip',impPROJdgn.elip,'Output'};
Panel(4,:) = {'VoxNom (mm3)',((impPROJdgn.vox)^3)*(1/impPROJdgn.elip),'Output'};
Panel(5,:) = {'VoxCeq (mm3)',((impPROJdgn.vox*1.24)^3)*(1/impPROJdgn.elip),'Output'};
Panel(6,:) = {'Nproj',impPROJdgn.nproj,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
IMP.DesPanelOutput = PanelOutput;    

%--------------------------------------------
% Output Structure
%--------------------------------------------
if strcmp(TST.testing,'Yes');
    IMP.GQKSA = IMETH.GQKSA;
    IMP.KSA = IMETH.KSA;
    IMP.T = IMETH.T;
end
IMETH = rmfield(IMETH,{'GQKSA' 'KSA' 'T'});
    
IMP.PROJimp = PROJimp;
IMP.PROJdgn = DES.PROJdgn;
IMP.impPROJdgn = impPROJdgn;
IMP.SYS = SYS;
IMP.PSMP = IMETH.PSMP;
IMP.GWFM = IMETH;
IMP.TSMP = IMETH.TSMP;
IMP.KSMP = KSMP;
IMP.samp = samp;
IMP.Kmat = Kmat;
IMP.Kend = Kend;
IMP.G = G;
IMP.qTscnr = qTscnr;

Status('done','');
Status2('done','',2);
Status2('done','',3);


