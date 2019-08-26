%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_TpiSmooth_v1a_Func(DESMETH,INPUT)

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
DESMETH.genprojfunc = 'GenProj_TpiSmooth_v1a';

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

%----------------------------------------------------
% Get Radial Evolution Design Function
%----------------------------------------------------
Status2('busy','Get Radial Evolution Design',2);
func = str2func([TPIT.method,'_Func']);
INPUT = struct();
[TPIT,err] = func(TPIT,INPUT);
if err.flag ~= 0
    return
end
PROJdgn.p = TPIT.p;
if isfield(TPIT,'sdcR')
    PROJdgn.sdcR = TPIT.sdcR;
    PROJdgn.sdcTF = TPIT.sdcTF;
end

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

%PSMP.phi = PSMP.phi(end-20:end);
%PSMP.theta = PSMP.theta(end-20:end);
%PSMP.phi = PSMP.phi(1:2);
%PSMP.theta = PSMP.theta(1:2);

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
if strcmp(TST.testspeed,'rapid')
    INPUT.courseadjust = 'yes';    
else
    INPUT.courseadjust = 'no';
end
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

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj];

Status('done','');
Status2('done','',2);
Status2('done','',3);


