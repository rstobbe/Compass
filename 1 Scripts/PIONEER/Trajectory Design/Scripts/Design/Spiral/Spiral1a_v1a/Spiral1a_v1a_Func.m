%====================================================
% 
%====================================================

function [DES,err] = Spiral1a_v1a_Func(INPUT)

Status('busy','Create Spiral1 Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
DES = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
SPIN = INPUT.SPIN;
DESOL = INPUT.DESOL;
CACC = INPUT.CACC;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJdgn.genprojfunc = 'Spiral1_GenProj_v1a';
if not(exist(PROJdgn.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common Spiral routines must be added to path';
    return
end
genprojfunc = str2func(PROJdgn.genprojfunc);

%----------------------------------------------------
% Basic Calcs
%----------------------------------------------------
PROJdgn.kstep = 1000/PROJdgn.fov;                                          
PROJdgn.kmax = 1000/(2*PROJdgn.vox);
PROJdgn.rad = PROJdgn.kmax/PROJdgn.kstep;

%-----------------------------------------------
% Determine value of p associated with nproj
%-----------------------------------------------
PROJdgn.p = PROJdgn.nproj/(2*pi*PROJdgn.rad);                     % TWIRL

%------------------------------------------
% PSMP to solve 1 trajectory
%------------------------------------------
PSMP.theta = 0;

%------------------------------------------
% Testing
%------------------------------------------
TST.initstrght = 'No';
TST.relprojlenmeas = 'Yes';

%------------------------------------------
% Visualization
%------------------------------------------
SPIN.Vis = 'No';
CACC.Vis = 'Yes';
DESOL.Vis = 'No';

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
INPUT.TST = TST;
func = str2func([PROJdgn.desoltimfunc,'_Func']);           
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
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
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

%---------------------------------------------
% Test
%---------------------------------------------
clf(figure(100));
plot(T0,KSA);
clf(figure(101));
plot(KSA(:,1),KSA(:,2));

%------------------------------------------
% Constrain Accelerations
%------------------------------------------    
INPUT.kArr = KSA;
INPUT.TArr = T0;
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.TST = TST;
func = str2func([PROJdgn.accconstfunc,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;   
T = CACC.TArr;

%------------------------------------------
% Consolidate Design Info
%------------------------------------------
PROJdgn.maxsmpdwell = PROJdgn.kstep/max(CACC.magvel);
PROJdgn.maxaveacc = CACC.maxaveacc;
PROJdgn.projosamp = SPIN.GblSamp;
PROJdgn.projlen = PROJdgn.projlen0*CACC.relprojleninc;
PROJdgn.elip = 1;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Method',PROJdgn.method,'Output'};
Panel(2,:) = {'','','Output'};
Panel(3,:) = {'FovDim (mm)',PROJdgn.fov,'Output'};
Panel(4,:) = {'VoxDim (mm)',PROJdgn.vox,'Output'};
Panel(5,:) = {'VoxCeq (mm3)',(PROJdgn.vox*1.24)^3,'Output'};
Panel(6,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel(7,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel(8,:) = {'','','Output'};
Panel(9,:) = {'p',PROJdgn.p,'Output'};
Panel(10,:) = {'projlen0',PROJdgn.projlen0,'Output'};
Panel(11,:) = {'dwellcrit0',PROJdgn.dwellcrit0,'Output'};
Panel(12,:) = {'PostCACC_MaxAveAcc',PROJdgn.maxaveacc,'Output'};
Panel(13,:) = {'PostCACC_MaxSampDwell',PROJdgn.maxsmpdwell,'Output'};

PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DES.PanelOutput = PanelOutput;

%------------------------------------------
% Return
%------------------------------------------
SPIN = rmfield(SPIN,'spincalcnprojfunc');       % wont save nice

DES.PROJdgn = PROJdgn;
DES.SPIN = SPIN;
DES.DESOL = DESOL;
DES.PSMP = PSMP;
DES.CACC = CACC;
DES.T = T;
DES.KSA = KSA;

Status('done','');
Status2('done','',2);
Status2('done','',3);


