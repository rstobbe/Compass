%==================================================
% Constrain Acceleration
%==================================================

function [CACC,err] = ConstEvol_v2a_Func(CACC,INPUT)

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
CACCT = CACC.CACCT;
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
kArr0 = kArr0*kmax;

%---------------------------------------------
% Test
%---------------------------------------------
test = kArr0(1:3,1);
test2 = TArr0(length(TArr0));
clf(figure(100));
plot(TArr0,kArr0);

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccfunc = str2func([CACC.caccfunc,'_Func']);
caccproffunc = str2func([CACC.caccproffunc,'_Func']);
cacctwkfunc = str2func([CACC.cacctwkfunc,'_Func']);
cjerkfunc = str2func([CACC.cjerkfunc,'_Func']);

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
    ylim([0 2000]);
    
    figure(1031); hold on; 
    plot(r,magacc0,'k-');
    xlabel('Rel Rad'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    ylim([0 2000]);
    ylim([0 1e6]);
    
    figure(2021); hold on; 
    plot(r,magvel0,'k-'); 
    xlabel('Rel Rad'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 0.2]);
    ylim([0 2000]);
    
    figure(2031); hold on; 
    plot(r,magacc0,'k-');
    xlabel('Rel Rad'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 0.2]);
    ylim([0 15000]);
    
    figure(2041); hold on; 
    plot(r,magjerk0,'k-');
    xlabel('Rel Rad'); ylabel('Trajectory Jerk'); title('Trajectory Jerk');
    xlim([0 0.2]);     
    ylim([0 7e5]);  
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
slvno = length(magacc0);  
DesAccProf = accproffunc(r);
ScaleAccProf = magacc0(slvno)*ones(1,slvno).*accproffunc(r);

%====================================================
% Constrain Acceleration (no Tweak)
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
TArrAC1 = CACCM.TArr;
test = max(TArrAC1)

%------------------------------------------
% Fix Time
%------------------------------------------
TArrAC1 = tro*TArrAC1/TArrAC1(length(TArrAC1));

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 5e-6;
iTArrAC1 = (0:interpstep:TArrAC1(length(TArrAC1)));
ikArrAC1 = interp1(TArrAC1,kArr0,iTArrAC1,'spline');
irelrAC1 = (sqrt(ikArrAC1(:,1).^2 + ikArrAC1(:,2).^2 + ikArrAC1(:,3).^2))/kmax;

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(ikArrAC1,iTArrAC1);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvelAC1 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magaccAC1 = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerkAC1 = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Plot
%------------------------------------------
if strcmp(CACC.Vis,'Yes') 

    figure(1001); hold on;
    plot(TArr0,r,'r');
    plot(iTArrAC1,irelrAC1);
    
    figure(1021); hold on; 
    plot(irelrAC1,magvelAC1,'c-'); 
    
    figure(3031); hold on; 
    plot(irelrAC1,magaccAC1,'c-');
    
    figure(1041); hold on; 
    plot(irelrAC1,magjerkAC1,'c-'); 
    
    figure(2021); hold on; 
    plot(irelrAC1,magvelAC1,'c-'); 
    
    figure(2031); hold on; 
    plot(irelrAC1,magaccAC1,'c-');
    
    figure(2041); hold on; 
    plot(irelrAC1,magjerkAC1,'c-'); 
end

error();

%------------------------------------------
% Tweak Acceleration Profile
%------------------------------------------        
clear INPUT;
INPUT.r = r;
INPUT.AccProf = ScaleAccProf;
[CACCT,err] = cacctwkfunc(CACCT,INPUT);
if err.flag
    return
end
clear INPUT;   
ScaleAccProf = CACCT.TwkAccProf;

%==================================================
% Constrain Acceleration (with Tweak)
%==================================================
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr0;
INPUT.ScaleAccProf = ScaleAccProf;
INPUT.MagAcc = magacc0;
[CACCM,err] = caccfunc(CACCM,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArrAC2 = CACCM.TArr;
relprojlenincAC2 = TArrAC2(slvno)/tro;

%------------------------------------------
% Fix Time
%------------------------------------------
TArrAC2 = tro*TArrAC2/TArrAC2(length(TArrAC2));

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 5e-6;
iTArrAC2 = (0:interpstep:TArrAC2(length(TArrAC2)));
ikArrAC2 = interp1(TArrAC2,kArr0,iTArrAC2,'spline');
irelrAC2 = (sqrt(ikArrAC2(:,1).^2 + ikArrAC2(:,2).^2 + ikArrAC2(:,3).^2))/kmax;

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(ikArrAC2,iTArrAC2);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvelAC2 = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magaccAC2 = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerkAC2 = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Plot
%------------------------------------------
if strcmp(CACC.Vis,'Yes') 
    figure(2021); hold on; 
    plot(irelrAC2,magvelAC2,'r-'); 

    figure(2031); hold on; 
    plot(irelrAC2,magaccAC2,'r-');
 
    figure(2041); hold on; 
    plot(irelrAC2,magjerkAC2,'r-'); 

    figure(3021); hold on; 
    plot(Tvel,magvelAC2,'r-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); title('Trajectory Velocity');
    xlim([0 0.2]);
    ylim([0 2000]);
    
    figure(3031); hold on; 
    plot(Tacc,magaccAC2,'r-');
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); title('Trajectory Acceleration');
    xlim([0 0.2]);
    ylim([0 15000]);
    
    figure(3041); hold on; 
    plot(Tjerk,magjerkAC2,'r-'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory Jerk'); title('Trajectory Jerk');
    xlim([0 0.2]);     
    ylim([0 7e5]); 
    
end

%=================================================
% Constrain Jerk
%=================================================
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = iTArrAC2;
[CACCJ,err] = cjerkfunc(CACCJ,INPUT);
if err.flag == 1
    return
end
clear INPUT;
TArrJC = CACCJ.TArr;
kArrJC = ikArrAC2;
relprojlenincJC = TArrJC(length(TArrJC))/tro;

%------------------------------------------
% Fix Time
%------------------------------------------
TArrJC = tro*TArrJC/TArrJC(length(TArrJC));

%------------------------------------------
% Test
%------------------------------------------
if TArrJC(2) > 0.0001;
    error('need finer interpolation');
end

%------------------------------------------
% Interpolate
%------------------------------------------
interpstep = 0.0001;
iTArrJC = (0:interpstep:TArrJC(length(TArrJC)));
ikArrJC = interp1(TArrJC,kArrJC,iTArrJC,'spline');

%------------------------------------------
% Calculate Timings
%------------------------------------------    
[vel,Tvel] = calcvelfunc(ikArrJC,iTArrJC);
[acc,Tacc] = calcaccfunc(vel,Tvel);
[jerk,Tjerk] = calcjerkfunc(acc,Tacc);
magvel = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
magjerk = sqrt(jerk(:,1).^2 + jerk(:,2).^2 + jerk(:,3).^2);  

%------------------------------------------
% Test
%------------------------------------------
if strcmp(CACC.Vis,'Yes')
    figure(3021); hold on; 
    plot(Tvel,magvel,'b-'); 

    figure(3031); hold on; 
    plot(Tacc,magacc,'b-');
    %plot(Tacc,acc(:,1),'b:'); plot(Tacc,acc(:,2),'b:'); plot(Tacc,acc(:,3),'b:');
    
    figure(3041); hold on; 
    plot(Tjerk,magjerk,'b-');
        
    %figure(2050); hold on; 
    %plot(iTArrJC,ikArrJC(:,1),'b-'); plot(iTArrJC,ikArrJC(:,2),'g-'); plot(iTArrJC,ikArrJC(:,3),'r-');    
end

%---------------------------------------------
% Return
%--------------------------------------------- 
CACC.DesAccProf = DesAccProf;
CACC.TArr = iTArrJC;
CACC.kArr = ikArrJC/kmax;
CACC.magvel = magvel;
CACC.magacc = magacc;
CACC.maxaveacc = mean(magacc(length(magacc)-100:length(magacc)));
CACC.relprojleninc = relprojlenincAC2 * relprojlenincJC;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);


