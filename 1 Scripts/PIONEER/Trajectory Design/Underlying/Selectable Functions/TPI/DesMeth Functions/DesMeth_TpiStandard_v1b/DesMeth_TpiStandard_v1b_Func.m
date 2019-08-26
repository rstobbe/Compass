%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_TpiStandard_v1b_Func(DESMETH,INPUT)

Status('busy','Create TPI Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------------
% Get Input
%----------------------------------------------------
PROJdgn = INPUT.PROJdgn;
ELIP = DESMETH.ELIP;
TPIT = DESMETH.TPIT;
RADEV = DESMETH.RADEV;
DESOL = DESMETH.DESOL;
PSMP = DESMETH.PSMP;
TST = DESMETH.TST;
clear INPUT

%----------------------------------------------------
% Describe Trajectory
%----------------------------------------------------
DESMETH.type = 'TPI';
DESMETH.genprojfunc = 'GenProj_TpiStandard_v1b';

%------------------------------------------
% Get Testing Info
%------------------------------------------
INPUT.func = 'GetInfo';
INPUT.DESMETH = DESMETH;
func = str2func([TST.method,'_Func']);           
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT;
DESOL.Vis = TST.DESOL.Vis;

%------------------------------------------
% Get voxel shape function
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([ELIP.method,'_Func']);           
[ELIP,err] = func(ELIP,INPUT);
if err.flag
    return
end
PROJdgn.elip = ELIP.elip;
clear INPUT;

%----------------------------------------------------
% Get Radial Evolution Design Function
%----------------------------------------------------
Status2('busy','Get Radial Evolution Design',2);
func = str2func([TPIT.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
[TPIT,err] = func(TPIT,INPUT);
if err.flag ~= 0
    return
end
PROJdgn.p = TPIT.p;

%------------------------------------------
% Projection Sampling
%------------------------------------------
func = str2func([PSMP.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.testing = 'Yes';     
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJdgn.projosamp = PSMP.projosamp;
PROJdgn.edgeSD = TPIT.edgeSDnoPos * PROJdgn.projosamp;

%------------------------------------------
% Get radial evolution function 
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([RADEV.method,'_Func']);           
[RADEV,err] = func(RADEV,INPUT);
if err.flag
    return
end
clear INPUT;
TST.relprojlenmeas = RADEV.relprojlenmeas;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = RADEV;
INPUT.TPIT = TPIT;
func = str2func([DESOL.method,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Solve Trajectory
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TPIT = TPIT;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
genprojfunc = str2func(DESMETH.genprojfunc);
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = squeeze(OUTPUT.KSA);
T0 = OUTPUT.T;
PROJdgn.TPIprojlen = DESOL.plout+PROJdgn.p;
PROJdgn.TPIiseg = PROJdgn.tro*PROJdgn.p/(DESOL.plout+PROJdgn.p);
PROJdgn.TPIirate = (PROJdgn.p*PROJdgn.kmax)/PROJdgn.TPIiseg;
PROJdgn.TPIkradat03ms = PROJdgn.TPIirate*0.3;
PROJdgn.projlen0 = OUTPUT.projlen0;
PROJdgn.dwellcrit0 = ((PROJdgn.p/PROJdgn.projlen0)*PROJdgn.tro)/(PROJdgn.rad*PROJdgn.p);
clear OUTPUT;
clear INPUT;

%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.ELIP = ELIP;
DESMETH.TPIT = TPIT;
DESMETH.RADEV = RADEV;
DESMETH.DESOL = DESOL;
DESMETH.PSMP = PSMP;
DESMETH.T0 = T0;
DESMETH.KSA = KSA;

%------------------------------------------
% Run Test Plots
%------------------------------------------
INPUT.func = 'TestPlot';
INPUT.DESMETH = DESMETH;
func = str2func([TST.method,'_Func']);           
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
DESMETH.PanelOutput = TST.PanelOutput;
DESMETH.Panel2Imp = TST.Panel2Imp;
DESMETH.name = TPIT.name0;


Status('done','');
Status2('done','',2);
Status2('done','',3);


