%=========================================================
% 
%=========================================================

function [IMP,err] = Implement_Proj3D_v1i_Func(INPUT,IMP)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
NUC = INPUT.NUC;
SYS = INPUT.SYS;
IMETH = INPUT.IMETH;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
testing = INPUT.testingonly;
clear INPUT;

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
func = str2func([IMP.psmpfunc,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
INPUT.testing = 'No';
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;

%----------------------------------------------------
% Test/Modify Design
%----------------------------------------------------
Status('busy','Test/Tweak Design for Implementation');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.SYS = SYS;
INPUT.PSMP = PSMP;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'TestTweak';
INPUT.testing = testing;
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
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'GenDes';
INPUT.testing = testing;
INPUT.PSMP = PSMP;
INPUT.impPROJdgn = impPROJdgn;
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Create Gradient Waveforms
%----------------------------------------------------
Status('busy','Create Gradient Waveforms');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.SYS = SYS;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'Build';
INPUT.testing = testing;
[IMETH,err] = func(IMETH,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
Status('busy','Define Trajectory Sampling');
func = str2func([IMP.tsmpfunc,'_Func']);
INPUT.PROJdgn = impPROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.GWFM = IMETH;
INPUT.SYS = SYS;
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    ErrDisp(err);
    return
end
clear INPUT
PROJimp.dwell = TSMP.dwell;
PROJimp.tro = TSMP.tro;
PROJimp.trajosamp = TSMP.trajosamp;

%---------------------------------------
% Resample k-Space
%---------------------------------------
Status('busy','Resample k-Space');
func = str2func([IMP.impmethfunc,'_Func']);
INPUT.DES = DES;
INPUT.SYS = SYS;
INPUT.TSMP = TSMP;
INPUT.PSMP = PSMP;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'Recon';
INPUT.testing = testing;
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
if strcmp(testing,'Yes');
    IMP.GQKSA = IMETH.GQKSA;
    IMP.KSA = IMETH.KSA;
    IMP.T = IMETH.T;
end
IMETH = rmfield(IMETH,{'GQKSA' 'KSA' 'T'});
    
IMP.PROJimp = PROJimp;
IMP.PROJdgn = DES.PROJdgn;
IMP.impPROJdgn = impPROJdgn;
IMP.SYS = SYS;
IMP.PSMP = PSMP;
IMP.GWFM = IMETH;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;
IMP.samp = samp;
IMP.Kmat = Kmat;
IMP.Kend = Kend;
IMP.G = G;
IMP.qTscnr = qTscnr;

Status('done','');
Status2('done','',2);
Status2('done','',3);


