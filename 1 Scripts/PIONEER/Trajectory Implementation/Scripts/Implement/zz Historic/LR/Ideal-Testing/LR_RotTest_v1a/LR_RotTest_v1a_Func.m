%=========================================================
% 
%=========================================================

function [IMP,err] = LR_RotTest_v1a_Func(INPUT)

Status('busy','Trajectory Rotation Testing');
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
TST.initstrght = PROJimp.initstraight;
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
    PSMP.phi = [0 0];
    PSMP.theta = [0 pi/4];
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
IMP.KSA = KSA;
IMP.T = T;
clear OUTPUT;
clear INPUT;

%---------------------------------------------
% Rotation Test
%---------------------------------------------
rKSA = Rotate3DPointsAboutZ_v1a(squeeze(KSA(1,:,:)),pi/4);
figure(1); hold on;
plot3(squeeze(KSA(2,:,1)),squeeze(KSA(2,:,2)),squeeze(KSA(2,:,3)),'b','linewidth',1);
plot3(squeeze(rKSA(:,1)),squeeze(rKSA(:,2)),squeeze(rKSA(:,3)),'r','linewidth',1);

figure(2); hold on;
plot(squeeze(KSA(1,:,3)));
plot(squeeze(KSA(2,:,3)));

Status('done','');
Status2('done','',2);
Status2('done','',3);
