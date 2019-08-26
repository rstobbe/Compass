%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_v3c_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
CACC.calcvelfunc = 'CalcVel_v2a';
CACC.calcaccfunc = 'CalcAcc_v2a';
CACC.calcjerkfunc = 'CalcJerk_v2a';
if not(exist(CACC.calcaccfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
calcvelfunc = str2func(CACC.calcvelfunc);
calcaccfunc = str2func(CACC.calcaccfunc);
calcjerkfunc = str2func(CACC.calcjerkfunc);

%---------------------------------------------
% Get Input
%---------------------------------------------
CACCM = CACC.CACCM;
PROJdgn = INPUT.PROJdgn;
kArr = INPUT.kArr * PROJdgn.kmax;
TArr0 = INPUT.TArr;
RADEV = INPUT.DESOL.RADEV;
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if strcmp(TST.relprojlenmeas,'Yes')
    if not(strcmp(RADEV.relprojlenmeas,'Yes'))
        err.flag = 1;
        err.msg = 'Select RadSolEvfunc for Design Testing';
        return
    end
end

%---------------------------------------------
% Common Variables
%---------------------------------------------
tro = PROJdgn.tro;
r = (sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2))/PROJdgn.kmax; 

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccfunc = str2func([CACC.caccfunc,'_Func']);

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel0] = calcvelfunc(kArr,TArr0);
[acc,Tacc0] = calcaccfunc(vel,Tvel0);
[jerk,Tjerk0] = calcjerkfunc(acc,Tacc0);
magvel0 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc0 = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk0 = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Initial Visualization
%------------------------------------------  
if strcmp(CACC.Vis,'Yes')
    figure(1021); hold on; 
    plot(Tvel0,magvel0,'k-'); 
    xlabel('tro (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 tro]);
    ylim([0 2000]);
    figure(1031); hold on; 
    plot(Tacc0,magacc0,'k-');
    xlabel('tro (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 tro]);
    ylim([0 15000]); 
    figure(1041); hold on; 
    plot(Tjerk0,magjerk0,'k-');
    xlabel('tro (ms)'); ylabel('Trajectory Jerk'); title('Trajectory Jerk');
    xlim([0 tro]);     
    ylim([0 7e5]);  
end

%------------------------------------------
% Constrain Acceleration 
%------------------------------------------
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr0;
INPUT.kArr = kArr;
INPUT.MagAcc = magacc0;
[CACCM,err] = caccfunc(CACCM,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArr = CACCM.TArr;

%------------------------------------------
% Fix Time
%------------------------------------------
TArr = tro*TArr/TArr(length(TArr));

%------------------------------------------
% Interpolate
%------------------------------------------
%interpstep = 0.0001;
%iTArr = (0:interpstep:TArr(length(TArr)));
%ikArr = interp1(TArr,kArr,iTArr,'spline');
%irelr = (sqrt(ikArr(:,1).^2 + ikArr(:,2).^2 + ikArr(:,3).^2))/PROJdgn.kmax;

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr,TArr);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Plot
%------------------------------------------
if strcmp(CACC.Vis,'Yes')   
    figure(1021); hold on; 
    plot(Tvel,magvel,'r-'); 
    figure(1031); hold on; 
    plot(Tacc,magacc,'r-');    
    figure(1041); hold on; 
    plot(Tjerk,magjerk,'r-'); 
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.TArr = TArr;
CACC.r = r;
CACC.Tvel0 = Tvel0;
CACC.Tacc0 = Tacc0;
CACC.Tjerk0 = Tjerk0;
CACC.magvel0 = magvel0;
CACC.magacc0 = magacc0;
CACC.magjerk0 = magjerk0;
CACC.Tvel = Tvel;
CACC.Tacc = Tacc;
CACC.Tjerk = Tjerk;
CACC.magvel = magvel;
CACC.magacc = magacc;
CACC.magjerk = magjerk;
CACC.maxaveacc = mean(magacc(length(magacc)-100:length(magacc)));
CACC.relprojleninc = CACCM.relprojleninc;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


