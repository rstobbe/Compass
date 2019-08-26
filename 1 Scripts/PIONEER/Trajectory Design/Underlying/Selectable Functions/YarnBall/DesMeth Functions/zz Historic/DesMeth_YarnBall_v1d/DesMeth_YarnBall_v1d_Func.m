%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBall_v1d_Func(DESMETH,INPUT)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
ELIP = DESMETH.ELIP;
SPIN = DESMETH.SPIN;
RADEV = DESMETH.RADEV;
DESOL = DESMETH.DESOL;
CACC = DESMETH.CACC;
CLR = DESMETH.CLR;
TST = DESMETH.TST;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'YB';
DESMETH.genprojfunc = 'GenProj_YarnBall_v1d';

%------------------------------------------
% Spiral Accommodation
%------------------------------------------
SpiralOverShoot = 0;
PROJdgn.spiralaccom = (PROJdgn.rad+SpiralOverShoot)/PROJdgn.rad;

%-----------------------------------------------
% Determine value of p associated with nproj
%-----------------------------------------------
PROJdgn.p = sqrt(PROJdgn.nproj/(2*pi^2*PROJdgn.rad^2));                     

%------------------------------------------
% PSMP to solve 1 trajectory
%------------------------------------------
PSMP.phi = pi/2;
PSMP.theta = 0;

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
SPIN.Vis = TST.SPIN.Vis;
CACC.Vis = TST.CACC.Vis;
DESOL.Vis = TST.DESOL.Vis;

%------------------------------------------
% Get colour function
%------------------------------------------
func = str2func([CLR.method,'_Func']);    
INPUT = [];
[CLR,err] = func(CLR,INPUT);
if err.flag
    return
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
% Get spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([SPIN.method,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
if isfield(SPIN,'p')
    PROJdgn.p = SPIN.p;
end
if isfield(SPIN,'nproj')
    PROJdgn.nproj = SPIN.nproj;
end

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
INPUT.CLR = CLR;
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
INPUT.SPIN = SPIN;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
INPUT.CLR = CLR;
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
% Constrain Acceleration
%------------------------------------------    
INPUT.kArr = KSA;
INPUT.TArr = T0;
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = RADEV;
INPUT.TST = TST;
INPUT.check = 0;
func = str2func([CACC.method,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;   
    
%------------------------------------------
% Consolidate Design Info
%------------------------------------------
PROJdgn.maxsmpdwell = PROJdgn.kstep/max(CACC.magvel);
PROJdgn.maxaveacc = CACC.maxaveacc;
PROJdgn.projosamp = SPIN.GblSamp;
PROJdgn.projlen = PROJdgn.projlen0*CACC.relprojleninc;

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
DESMETH.name = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_S',SPIN.name];

%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.CLR = CLR;
DESMETH.RADEV = RADEV;
DESMETH.DESOL = DESOL;
DESMETH.PSMP = PSMP;
DESMETH.CACC = CACC;
DESMETH.T0 = T0;
DESMETH.Tcacc = CACC.TArr;
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

Status('done','');
Status2('done','',2);
Status2('done','',3);


