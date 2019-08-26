%==================================================
% Constrain Acceleration
%==================================================

function [CACC,err] = ConstEvol_v1b_Func(CACC,INPUT)

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

%test = max(r)

%---------------------------------------------
% Common Variables
%---------------------------------------------
kmax = PROJdgn.kmax;
tro = PROJdgn.tro;
kArr0 = kArr0*kmax;

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccfunc = str2func([CACC.caccfunc,'_Func']);
caccproffunc = str2func([CACC.caccproffunc,'_Func']);
cjerkfunc = str2func([CACC.cjerkfunc,'_Func']);

%------------------------------------------
% TArr0 Test
%------------------------------------------
%if strcmp(CACC.Vis,'Yes')
%    figure(2011); hold on; 
%    plot(TArr0,'k-'); 
%    ylabel('TArr0');
%
%    figure(2012); hold on; 
%    plot(TArr0(1:10),'k-'); 
%    ylabel('TArr0');
%    ylim([0 1e-4]);
%end

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr0,TArr0);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Initial Visualization
%------------------------------------------  
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(Tvel,magvel,'k-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); 
    title('Trajectory Velocity');
    ylim([0 3000]);

    %figure(2022); hold on; 
    %plot(Tvel,magvel,'k-*'); 
    %xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); 
    %title('Trajectory Velocity');
    %ylim([0 10000]);
    %xlim([0 0.3]); 
    
    %figure(2023); hold on; 
    %plot(Tvel,magvel,'k-*'); 
    %xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); 
    %title('Trajectory Velocity');
    %xlim([0 0.03])
    
    figure(2031); hold on; 
    plot(Tacc,magacc,'k-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Acceleration');
    ylim([0 15000]);
    
    %figure(2032); hold on; 
    %plot(Tacc,magacc,'k-*');
    %xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    %title('Trajectory Acceleration');
    %ylim([0 50000]);  
    %xlim([0 0.3]); 
    
    %figure(2033); hold on; 
    %plot(Tacc,magacc,'k-*');
    %xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    %title('Trajectory Acceleration');
    %xlim([0 0.03]);     

    figure(2041); hold on; 
    plot(Tacc,magacc,'k-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Jerk');
    ylim([0 5e5]);
    
    %figure(2043); hold on; 
    %plot(Tjerk,magjerk,'k-*');
    %xlabel('Readout Time (ms)'); ylabel('Trajectory Jerk'); 
    %title('Trajectory Jerk');
    %ylim([0 1e9]);
    %xlim([0 0.03]);         
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

AccAdj = ones(1,slvno) + 4*exp(-r/0.02) - 4.4*exp(-r/0.002);
ScaleAccProf = ScaleAccProf.*AccAdj;

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
Tsegs = CACCM.Tsegs;
TArrC = CACCM.TArr;
TArr0 = TArrC;
relprojleninc1 = TArr0(slvno)/tro;

%------------------------------------------
% Fix Time
%------------------------------------------
TArr0 = tro*TArr0/TArr0(length(TArr0));

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 5e-6;
TArr = (0:interpstep:TArr0(length(TArr0)));
kArr = interp1(TArr0,kArr0,TArr,'spline');

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
    figure(2001); hold on; 
    plot(TArrC(1:length(TArrC)-1),Tsegs(2:length(Tsegs)),'r-'); 
    
    figure(2021); hold on; 
    plot(Tvel,magvel,'r-'); 

    figure(2031); hold on; 
    plot(Tacc,magacc,'r-');
 
    %figure(2034); hold on; 
    %r = sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2)/kmax;
    %plot(r,magacc,'r-');

    figure(2041); hold on; 
    plot(Tjerk,magjerk,'r-'); 
        
    figure(2050); hold on; 
    plot(TArr,kArr(:,1),'b-'); plot(TArr,kArr(:,2),'g-'); plot(TArr,kArr(:,3),'r-'); 
    plot(TArr0,kArr0(:,1),'b-'); plot(TArr0,kArr0(:,2),'g-'); plot(TArr0,kArr0(:,3),'r-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory'); 
    title('Trajectory');
    
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
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Test
%------------------------------------------
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(Tvel,magvel,'b-'); 

    figure(2031); hold on; 
    plot(Tacc,magacc,'b-');
 
    figure(2041); hold on; 
    plot(Tjerk,magjerk,'b-');
        
    figure(2050); hold on; 
    plot(TArr,kArr(:,1),'b-'); plot(TArr,kArr(:,2),'g-'); plot(TArr,kArr(:,3),'r-');    
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


