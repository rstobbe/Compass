%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBall_v1e_Func(DESMETH,INPUT)

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
DESOL = DESMETH.DESOL;
CACC = DESMETH.CACC;
CLR = DESMETH.CLR;
TST = DESMETH.TST;
IMPTYPE = DESMETH.IMPTYPE;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'YB';
DESMETH.genprojfunc = 'GenProj_YarnBall_v1e2';

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
% 'Basic' ImpType
%------------------------------------------
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
INPUT.SPIN = SPIN;
INPUT.PROJdgn = PROJdgn;
INPUT.loc = 'PreDeSolTim';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.IMPTYPE = IMPTYPE;
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
T0 = DESOL.T;

%------------------------------------------
% 'Basic' ImpType
%------------------------------------------
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
INPUT.PROJdgn = PROJdgn;
INPUT.loc = 'PreGeneration';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Solve Trajectory
%------------------------------------------
INPUT.IMPTYPE = IMPTYPE;
genprojfunc = str2func(DESMETH.genprojfunc);
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = squeeze(OUTPUT.KSA);
clear OUTPUT;
clear INPUT;

%------------------------------------------
% Constrain Acceleration
%------------------------------------------    
INPUT.kArr = KSA;
INPUT.TArr = T0;
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = DESOL.RADEV;
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
DESMETH.IMPTYPE = IMPTYPE;
DESMETH.RADEV = DESOL.RADEV;
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


