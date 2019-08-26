%==================================================
% Constrain Acceleration
%==================================================

function [CACC,err] = ConstEvol_v1a_Func(CACC,INPUT)

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
CACCP = CACC.CACCP;
CACCJ = CACC.CACCJ;
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
r = INPUT.r;
kArr0 = INPUT.kArr;
TArr0 = INPUT.TArr;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kmax = PROJdgn.kmax;
tro = PROJdgn.tro;

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccfunc = str2func([CACC.caccfunc,'_Func']);
caccproffunc = str2func([CACC.caccproffunc,'_Func']);
cjerkfunc = str2func([CACC.cjerkfunc,'_Func']);

%------------------------------------------
% Calculate Timings
%------------------------------------------    
kArr0 = kArr0*kmax;
[vel,Tvel] = calcvelfunc(kArr0,TArr0);
[acc,Tacc] = calcaccfunc(vel,Tvel);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);

%------------------------------------------
% Initial Visualization
%------------------------------------------  
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(Tvel,magvel,'k-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); 
    title('Trajectory Velocity');
    ylim([0 3000]);

    figure(2031); hold on; 
    plot(Tacc,magacc,'k-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Acceleration');
    ylim([0 15000]);
end

%------------------------------------------
% Return if not Constrain Acceleration
%------------------------------------------                   
if strcmp(TST.constacc,'No')        
    return
end

%------------------------------------------
% Get Desired Acceleration Profile
%------------------------------------------        
clear INPUT;   
INPUT.PROJdgn = PROJdgn;
[CACCP,err] = caccproffunc(CACCP,INPUT);
if err.flag
    return
end
clear INPUT;   
accproffunc = str2func(['@(r)' CACCP.AccProf]);

%------------------------------------------
% Scale Acceleration Profile
%------------------------------------------ 
slvno = length(magacc);  
DesAccProf = accproffunc(r);
ScaleAccProf = magacc(slvno)*ones(1,slvno).*accproffunc(r);
 
%------------------------------------------
% Constrain Acceleration
%------------------------------------------
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr0;
INPUT.ScaleAccProf = ScaleAccProf;
INPUT.MagAcc = magacc;
[CACCM,err] = caccfunc(CACCM,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArr0 = CACCM.TArr;
relprojleninc1 = TArr0(slvno)/tro;

%------------------------------------------
% Fix Time
%------------------------------------------
TArr0 = tro*TArr0/TArr0(length(TArr0));

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 0.000005;
TArr = (0:interpstep:TArr0(length(TArr0)));
kArr = interp1(TArr0,kArr0,TArr,'spline');

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr,TArr);
[acc,Tacc] = calcaccfunc(vel,Tvel);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);

%------------------------------------------
% Calculate Jerk
%------------------------------------------
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
jerk(:,1) = smooth(jerk(:,1),21);
jerk(:,2) = smooth(jerk(:,2),21);
jerk(:,3) = smooth(jerk(:,3),21);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Plot
%------------------------------------------
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(Tvel,magvel,'r-'); 

    figure(2031); hold on; 
    plot(Tacc,magacc,'r-');
 
    figure(2032); hold on; 
    plot(Tjerk,magjerk,'r-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Jerk'); 
    title('Trajectory Jerk');
    ylim([0 200000]);    
        
    figure(2040); hold on; 
    plot(TArr,kArr(:,1),'b-'); plot(TArr,kArr(:,2),'g-'); plot(TArr,kArr(:,3),'r-'); 
    plot(TArr0,kArr0(:,1),'b-'); plot(TArr0,kArr0(:,2),'g-'); plot(TArr0,kArr0(:,3),'r-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory'); 
    title('Trajectory');
    
    %figure(2041); hold on; plot(TArr0,'r-'); 
    %xlabel('Solution Segment'); ylabel('Segment Time'); 
    %title('Constrained Acceleration Solution Timing');

    %figure(2042); hold on; plot(CACCM.Tsegs,'r-'); 
    %xlabel('Solution Segment'); ylabel('Segment Duration'); 
    %title('Constrained Acceleration Solution Timing');
end

%------------------------------------------
% Constrain Jerk
%------------------------------------------
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr;
[CACCJ,err] = cjerkfunc(CACCJ,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArr0 = CACCJ.TArr;
kArr0 = kArr;
relprojleninc2 = TArr0(length(TArr0))/tro;

%------------------------------------------
% Fix Time
%------------------------------------------
TArr0 = tro*TArr0/TArr0(length(TArr0));

%------------------------------------------
% Test
%------------------------------------------
if TArr0(2) > 0.001;
    error('need finer interpolation');
end

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 0.001;
TArr = (0:interpstep:TArr0(length(TArr0)));
kArr = interp1(TArr0,kArr0,TArr,'spline');

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr,TArr);
[acc,Tacc] = calcaccfunc(vel,Tvel);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);

%------------------------------------------
% Calculate Timings
%------------------------------------------
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
jerk(:,1) = smooth(jerk(:,1),21);
jerk(:,2) = smooth(jerk(:,2),21);
jerk(:,3) = smooth(jerk(:,3),21);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Test
%------------------------------------------
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(Tvel,magvel,'b-'); 

    figure(2031); hold on; 
    plot(Tacc,magacc,'b-');
 
    figure(2032); hold on; 
    plot(Tjerk,magjerk,'b-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Jerk'); 
        
    figure(2040); hold on; 
    plot(TArr,kArr(:,1),'b-'); plot(TArr,kArr(:,2),'g-'); plot(TArr,kArr(:,3),'r-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory'); 
    title('Trajectory');
    
    %figure(2041); hold on; plot(TArr,'b-'); 
    %xlabel('Solution Segment'); ylabel('Segment Time'); 
    %title('Constrained Acceleration Solution Timing');

    %figure(2042); hold on; plot(CACCJ.Tsegs,'b-'); 
    %xlabel('Solution Segment'); ylabel('Segment Duration'); 
    %title('Constrained Acceleration Solution Timing');
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.DesAccProf = DesAccProf;
CACC.TArr = TArr;
CACC.kArr = kArr/kmax;
CACC.magvel = magvel;
CACC.magacc = magacc;
CACC.maxaveacc = mean(magacc(length(magacc)-100:length(magacc)));
CACC.relprojleninc = relprojleninc1 * relprojleninc2;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


