%==================================================
% Constrain Acceleration
%==================================================

function [CACC,err] = CAccTop_v1b_Func(CACC,INPUT)

Status2('busy','Constrain Acceleration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
CACC.calcvelfunc = 'CalcVel_v1b';
CACC.calcaccfunc = 'CalcAcc_v1b';
if not(exist(CACC.calcaccfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
calcvelfunc = str2func(CACC.calcvelfunc);
calcaccfunc = str2func(CACC.calcaccfunc);

%---------------------------------------------
% Get Input
%---------------------------------------------
CACCM = CACC.CACCM;
CACCP = CACC.CACCP;
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
r = INPUT.r;
kArr = INPUT.kArr;
TArr0 = INPUT.TArr;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kmax = PROJdgn.kmax;
tro = PROJdgn.tro;

%---------------------------------------------
% Function Setup
%---------------------------------------------
caccmethfunc = str2func([CACC.caccmethfunc,'_Func']);
caccproffunc = str2func([CACC.caccproffunc,'_Func']);

%------------------------------------------
% Calculate Speed and Acceleration
%------------------------------------------    
kArr = kArr*kmax;
[vel] = calcvelfunc(kArr,TArr0);
[acc] = calcaccfunc(vel,TArr0);
CACC.magvelpre = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);
CACC.magaccpre = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);

%------------------------------------------
% Return if not Constrain Acceleration
%------------------------------------------                   
if strcmp(TST.constacc,'No')        
    CACC.magaccpost = CACC.magaccpre;
    CACC.magvelpost = CACC.magvelpre;
    CACC.maxacc = max(magaccpost);
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
slvno = length(CACC.magaccpre);  
CACC.DesAccProf = accproffunc(r);
ScaleAccProf = CACC.magaccpre(slvno)*ones(1,slvno).*accproffunc(r);
 
%------------------------------------------
% Constrain Acceleration
%------------------------------------------
clear INPUT;
INPUT.PROJdgn = PROJdgn;
INPUT.TArr0 = TArr0;
INPUT.ScaleAccProf = ScaleAccProf;
INPUT.MagAcc = CACC.magaccpre;
[CACCM,err] = caccmethfunc(CACCM,INPUT);
if err.flag == 1
    return
end
clear INPUT;

%------------------------------------------
% Recalculate Timing and Acceleration
%------------------------------------------
CACC.relprojleninc = CACCM.TArr(slvno)/tro;
CACC.TArr = tro*CACCM.TArr/CACCM.TArr(slvno);
[vel] = calcvelfunc(kArr,CACC.TArr);
[acc] = calcaccfunc(vel,CACC.TArr);
CACC.magaccpost = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
CACC.magvelpost = sqrt(vel(:,1).^2 + vel(:,2).^2 + vel(:,3).^2);      
CACC.maxaveacc = mean(CACC.magaccpost(slvno-100:slvno));

%------------------------------------------
% Test
%------------------------------------------
if strcmp(CACC.Vis,'Yes')
    figure(2021); hold on; 
    plot(CACC.TArr,CACC.magvelpre,'k','linewidth',2); 
    plot(CACC.TArr,CACC.magvelpost,'r','linewidth',2);
    xlabel('Readout Time (ms)'); ylabel('Trajectory Velocity'); 
    title('Trajectory Velocity');
    
    figure(2031); hold on; 
    plot(CACC.TArr,CACC.magaccpre,'k','linewidth',2); 
    plot(CACC.TArr,CACC.magaccpost,'r','linewidth',2);
    xlabel('Readout Time (ms)'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Acceleration');
    ylim([0 15000]);
    
    figure(2032); hold on; 
    kmag = sqrt(kArr(:,1).^2 + kArr(:,2).^2 + kArr(:,3).^2);
    plot(kmag,CACC.magaccpre,'k','linewidth',2); 
    plot(kmag,CACC.magaccpost,'r','linewidth',2);
    xlabel('kmag'); ylabel('Trajectory Acceleration'); 
    title('Trajectory Acceleration');
    ylim([0 15000]);
    
    figure(2040); hold on; 
    plot(CACC.TArr,kArr(:,1),'b-*'); plot(CACC.TArr,kArr(:,2),'g-*'); plot(CACC.TArr,kArr(:,3),'r-*'); 
    xlabel('Readout Time (ms)'); ylabel('Trajectory'); 
    title('Trajectory');
    
    figure(2041); hold on; plot(CACC.TArr,'k','linewidth',2); 
    xlabel('Solution Segment'); ylabel('Segment Time'); 
    title('Constrained Acceleration Solution Timing');
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CACC.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);