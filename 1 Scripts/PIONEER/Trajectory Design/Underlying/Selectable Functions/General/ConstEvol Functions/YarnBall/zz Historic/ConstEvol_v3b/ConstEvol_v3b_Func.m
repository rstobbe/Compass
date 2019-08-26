%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_v3b_Func(CACC,INPUT)

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
PROJdgn = INPUT.PROJdgn;
kArr0 = INPUT.kArr * PROJdgn.kmax;
TArr0 = INPUT.TArr;

%---------------------------------------------
% Common Variables
%---------------------------------------------
tro = PROJdgn.tro;
r = (sqrt(kArr0(:,1).^2 + kArr0(:,2).^2 + kArr0(:,3).^2))/PROJdgn.kmax; 

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccfunc = str2func([CACC.caccfunc,'_Func']);
caccproffunc = str2func([CACC.caccproffunc,'_Func']);

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(kArr0,TArr0);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel0 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc0 = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk0 = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Initial Visualization
%------------------------------------------  
if strcmp(CACC.Vis,'Yes')
    figure(1021); hold on; 
    plot(r,magvel0,'k-'); 
    xlabel('Rel Rad'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 1]);
    ylim([0 2000]);
    
    figure(1031); hold on; 
    plot(r,magacc0,'k-');
    xlabel('Rel Rad'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 1]);
    ylim([0 15000]);
       
    figure(1041); hold on; 
    plot(r,magjerk0,'k-');
    xlabel('Rel Rad'); ylabel('Trajectory Jerk'); title('Trajectory Jerk');
    xlim([0 1]);     
    ylim([0 7e5]);  
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
slvno = length(magacc0);  
DesAccProf = accproffunc(r);
ScaleAccProf = magacc0(slvno)*ones(1,slvno).*accproffunc(r);

%====================================================
% Constrain Acceleration 
%====================================================
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr0;
INPUT.kArr = kArr0;
INPUT.Tvel = Tvel;
INPUT.ScaleAccProf = ScaleAccProf;
INPUT.MagAcc = magacc0;
[CACCM,err] = caccfunc(CACCM,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArr = CACCM.TArr;
test = max(TArr)

%------------------------------------------
% Fix Time
%------------------------------------------
TArr = tro*TArr/TArr(length(TArr));

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 0.0001;
iTArr = (0:interpstep:TArr(length(TArr)));
ikArr = interp1(TArr,kArr0,iTArr,'spline');
irelr = (sqrt(ikArr(:,1).^2 + ikArr(:,2).^2 + ikArr(:,3).^2))/kmax;

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(ikArr,iTArr);
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
    plot(irelr,magvel,'r-'); 
    
    figure(1031); hold on; 
    plot(irelr,magacc,'r-');
    
    figure(1041); hold on; 
    plot(irelr,magjerk,'r-'); 
    
    figure(2021); hold on; 
    plot(irelr,magvel,'r-'); 
    
    figure(2031); hold on; 
    plot(irelr,magacc,'r-');
    
    figure(2041); hold on; 
    plot(irelr,magjerk,'r-'); 
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.DesAccProf = DesAccProf;
CACC.TArr = iTArr;
CACC.kArr = ikArr/kmax;
CACC.magvel = magvel;
CACC.magacc = magacc;
CACC.maxaveacc = mean(magacc(length(magacc)-100:length(magacc)));
CACC.relprojleninc = 1;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


