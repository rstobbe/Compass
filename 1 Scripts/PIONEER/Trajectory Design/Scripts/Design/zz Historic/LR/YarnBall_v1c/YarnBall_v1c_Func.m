%====================================================
% 
%====================================================

function [DES,err] = YarnBall_v1c_Func(INPUT,DES)

Status('busy','Create YarnBall Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ELIP = INPUT.ELIP;
SPIN = INPUT.SPIN;
DESOL = INPUT.DESOL;
CACC = INPUT.CACC;
clear INPUT

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DES.genprojfunc = 'LR1_GenProj_v1i';
if not(exist(DES.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(DES.genprojfunc);

%----------------------------------------------------
% Basic Calcs
%----------------------------------------------------
PROJdgn.method = DES.method;
PROJdgn.fov = DES.fov;
PROJdgn.vox = DES.vox;
PROJdgn.tro = DES.tro;
PROJdgn.nproj = DES.nproj;
PROJdgn.kstep = 1000/PROJdgn.fov;                                          
PROJdgn.kmax = 1000/(2*PROJdgn.vox);
PROJdgn.rad = PROJdgn.kmax/PROJdgn.kstep;

%-----------------------------------------------
% Determine value of p associated with nproj
%-----------------------------------------------
PROJdgn.p = sqrt(PROJdgn.nproj/(2*pi^2*PROJdgn.rad^2));                     % abstract ref...

%------------------------------------------
% PSMP to solve 1 trajectory
%------------------------------------------
PSMP.phi = pi/2;
PSMP.theta = 0;

%------------------------------------------
% Testing
%------------------------------------------
TST.initstrght = 'No';
TST.relprojlenmeas = 'Yes';
TST.testspeed = 'Rapid';

%------------------------------------------
% Visualization
%------------------------------------------
SPIN.Vis = 'Yes';
CACC.Vis = 'No';
DESOL.Vis = 'No';

%------------------------------------------
% Get LR elip function
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([DES.elipfunc,'_Func']);           
[ELIP,err] = func(ELIP,INPUT);
if err.flag
    return
end
PROJdgn.elip = ELIP.elip;
clear INPUT;

%------------------------------------------
% Get LR spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([DES.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
PROJdgn.spiralaccom = SPIN.spiralaccom;
if isfield(SPIN,'p')
    PROJdgn.p = SPIN.p;
end
if isfield(SPIN,'p')
    PROJdgn.nproj = SPIN.nproj;
end

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TST = TST;
func = str2func([DES.desoltimfunc,'_Func']);           
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
TrajVis = 1;
if TrajVis == 1
    Rad = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);
    ind = find(Rad >= 2*PROJdgn.p,1);
    ind2 = find(Rad >= PROJdgn.p,1);
    
    fh = figure(500); 
    fh.Name = 'Test Waveform';
    fh.NumberTitle = 'off';
    fh.Position = [400 150 1000 800];
    
    subplot(2,2,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(:,1),PROJdgn.rad*KSA(:,2),PROJdgn.rad*KSA(:,3),'k','linewidth',1);
    plot3(PROJdgn.rad*KSA(ind2,1),PROJdgn.rad*KSA(ind2,2),PROJdgn.rad*KSA(ind2,3),'rx','linewidth',1);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-31 -39 12.5]);  
    
    subplot(2,2,2); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1:ind,1),PROJdgn.rad*KSA(1:ind,2),PROJdgn.rad*KSA(1:ind,3),'k','linewidth',1);
    plot3(PROJdgn.rad*KSA(ind2,1),PROJdgn.rad*KSA(ind2,2),PROJdgn.rad*KSA(ind2,3),'rx','linewidth',1);
    lim = ceil(PROJdgn.rad*2*PROJdgn.p);
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-31 -39 12.5]); 
end

%------------------------------------------
% Constrain Accelerations
%------------------------------------------    
INPUT.kArr = KSA;
INPUT.TArr = T0;
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.TST = TST;
func = str2func([DES.accconstfunc,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;   
T = CACC.TArr;

%---------------------------------------------
% Test
%---------------------------------------------
if TrajVis == 1
    subplot(2,2,3); hold on; 
    plot(T,Rad);
    xlabel('ms'); ylabel('Relative Radius'); title('Radial Evolution');
end
    
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
Panel1(6,:) = {'PostCACC_MaxSampDwell',PROJdgn.maxsmpdwell,'Output'};

Panel = [Panel0;SPIN.Panel;Panel1];
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DES.PanelOutput = PanelOutput;

%------------------------------------------
% Return
%------------------------------------------
SPIN = rmfield(SPIN,'spincalcnprojfunc');       % wont save nice
SPIN = rmfield(SPIN,'spincalcndiscsfunc');

DES.PROJdgn = PROJdgn;
DES.ELIP = ELIP;
DES.SPIN = SPIN;
DES.DESOL = DESOL;
DES.PSMP = PSMP;
DES.CACC = CACC;
DES.T = T;
DES.KSA = KSA;

Status('done','');
Status2('done','',2);
Status2('done','',3);


