%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBallBasic_v1a_Func(DESMETH,INPUT)

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
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'YB';
DESMETH.genprojfunc = 'GenProj_YarnBallBasic_v1a';

%------------------------------------------
% Spiral Accommodation
%------------------------------------------
DESMETH.SpiralOverShoot = 0;
PROJdgn.spiralaccom = (PROJdgn.rad+DESMETH.SpiralOverShoot)/PROJdgn.rad;

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
% Testing
%------------------------------------------
TST.testspeed = 'Rapid';

%------------------------------------------
% Visualization
%------------------------------------------
SPIN.Vis = 'Yes';
CACC.Vis = 'No';
DESOL.Vis = 'No';

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
if isfield(SPIN,'p')
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
INPUT.TST = TST;
INPUT.RADEV = RADEV;
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

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel0(1,:) = {'Method',PROJdgn.method,'Output'};
Panel0(2,:) = {'FovDim (mm)',PROJdgn.fov,'Output'};
Panel0(3,:) = {'VoxDim (mm)',PROJdgn.vox,'Output'};
Panel0(4,:) = {'Elip',PROJdgn.elip,'Output'};
Panel0(5,:) = {'VoxNom (mm3)',((PROJdgn.vox)^3)*(1/PROJdgn.elip),'Output'};
Panel0(6,:) = {'VoxCeq (mm3)',((PROJdgn.vox*1.24)^3)*(1/PROJdgn.elip),'Output'};
Panel0(7,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel0(8,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel0(9,:) = {'','','Output'};

Panel1(1,:) = {'','','Output'};
Panel1(2,:) = {'p',PROJdgn.p,'Output'};
Panel1(3,:) = {'projlen0',PROJdgn.projlen0,'Output'};
Panel1(4,:) = {'dwellcrit0',PROJdgn.dwellcrit0,'Output'};
Panel1(5,:) = {'PostCACC_MaxAveAcc',PROJdgn.maxaveacc,'Output'};

Panel = [Panel0;SPIN.Panel;Panel1];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DESMETH.PanelOutput = PanelOutput;

%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.ELIP = ELIP;
DESMETH.SPIN = SPIN;
DESMETH.RADEV = RADEV;
DESMETH.DESOL = DESOL;
DESMETH.PSMP = PSMP;
DESMETH.CACC = CACC;
DESMETH.T0 = T0;
DESMETH.Tcacc = CACC.TArr;
DESMETH.KSA = KSA;

Status('done','');
Status2('done','',2);
Status2('done','',3);


