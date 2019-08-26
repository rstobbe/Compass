%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_DesignTest_v1a_Func(IMETH,INPUT)

Status2('busy','Implement for Design Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
if not(strcmp(INPUT.DES.type,'LR3D') || strcmp(INPUT.DES.type,'YB'))
    err.flag = 1;
    err.msg = 'ImpMeth_LRstandard is not valid for the trajectory design';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
SPIN = DES.SPIN;
CLR = DES.CLR;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
RADEV = IMETH.RADEV;
DESOL = IMETH.DESOL;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
CACC = IMETH.CACC;
clear INPUT

%---------------------------------------------
% Test for Design Routine
%---------------------------------------------
if not(exist(DES.genprojfunc,'file'))
    error;
end
genprojfunc = str2func(DES.genprojfunc);

%---------------------------------------------
% Update Visualization from Test Function
%---------------------------------------------
KSMP.Vis = TST.KSMP.Vis;
DESOL.Vis = TST.DESOL.Vis;
CACC.Vis = TST.CACC.Vis;
CDESOL = DESOL;                 % copy for evolution constraint

%===============================================================================
% Define Projection Sampling
%===============================================================================
func = str2func([IMETH.psmpfunc,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
INPUT.SPIN = DES.SPIN;
INPUT.testing = 'No';
if isfield(TST,'testprojsubset')
    if strcmp(TST.testprojsubset,'Yes')
        INPUT.testing = 'Yes';
    end
end      
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;
IMETH.PSMP = PSMP;
IMETH.PROJimp = PROJimp;

    
%===============================================================================
% Test 
%===============================================================================

%------------------------------------------
% Get spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([DES.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
if SPIN.p ~= PROJdgn.p
    error
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
TST.constevol = RADEV.constevol;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = RADEV;
if strcmp(TST.testspeed,'rapid')
    INPUT.courseadjust = 'yes';    
else
    INPUT.courseadjust = 'no';
end
func = str2func([DESOL.method,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Test Solution Fineness
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.CLR = CLR;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
if strcmp(TST.traj,'All')
    INPUT.PSMP.phi = PSMP.phi(1);
    INPUT.PSMP.theta = PSMP.theta(1);
else
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
if strcmp(TST.relprojlenmeas,'Yes')
    if OUTPUT.projlen0 ~= PROJdgn.projlen0
        error
    end
end
KSA = OUTPUT.KSA;
T = OUTPUT.T;
clear INPUT;
clear OUTPUT;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end    

%---------------------------------------------
% Test
%---------------------------------------------
m = 2:length(KSA(1,:,1));
kStep = [KSA(:,1,:) KSA(:,m,:) - KSA(:,m-1,:)];
MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
MagkStep = mean(MagkStep,1);
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end    

if strcmp(TST.TVis,'Yes')
    fh = figure(500); 
    fh.Name = 'Solution Fineness Testing for Waveform Generation';
    fh.NumberTitle = 'off';
    fh.Position = [200 150 1400 800];
    subplot(2,3,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Full Trajectory');

    subplot(2,3,2); hold on; axis equal; grid on; box off;
    ind = find(Rad >= 2*PROJdgn.p,1);    
    plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = ceil(PROJdgn.rad*2*PROJdgn.p);
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Initial Portion');
    set(gca,'cameraposition',[-31 -39 12.5]); 

    subplot(2,3,3); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = 0.5;
    xlim([-lim,lim]); ylim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[0 0 5000]);
    set(gca,'CameraTargetMode','manual');
    set(gca,'CameraTarget',[0 0 0]);
    set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5)); title('Solution Quantization Deflection @ Centre');

    subplot(2,3,4); hold on;
    plot(Rad,PROJdgn.rad*MagkStep,'k');
    plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
    plot([0 1],[0.1 0.1],':');
    plot([0 1],[1 1],':');
    ylim([0 1.1]);
    xlabel('Relative Radius'); ylabel('kStep'); xlim([0 1]); title('Solution Sampling Fineness');

    subplot(2,3,5); hold on;
    plot(T,PROJdgn.rad*KSA(1,:,1),'k');
    plot(T,PROJdgn.rad*KSA(1,:,2),'k');
    plot(T,PROJdgn.rad*KSA(1,:,3),'k');
    plot(T,zeros(size(T)),'k:');
    xlabel('(ms)'); ylabel('kSpace (steps)'); title('kSpace Quantization Test');   
    
    button = questdlg('Continue? (Test Solution Fineness for Waveform Generation)');
    if strcmp(button,'No');
        err.flag = 4;
        err.msg = '';
        return
    end    
end 
 

%===============================================================================
% Constrain Evolution
%===============================================================================
INPUT.check = 1;
func = str2func([CACC.method,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;
if strcmp(CACC.doconstraint,'Yes')

    %------------------------------------------
    % Get DE solution timing
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.RADEV = RADEV;
    INPUT.courseadjust = 'yes';    
    func = str2func([CDESOL.method,'_Func']);           
    [CDESOL,err] = func(CDESOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;

    %---------------------------------------------
    % Generate Test Trajectories
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.SPIN = SPIN;
    INPUT.CLR = CLR;
    INPUT.RADEV = RADEV;
    INPUT.DESOL = CDESOL;
    INPUT.PSMP.phi = [0,pi/4,pi/2,3*pi/4];
    INPUT.PSMP.theta = [0,0,0,0];
    INPUT.TST = TST;
    [OUTPUT,err] = genprojfunc(INPUT);
    if err.flag
        return
    end
    KSA = OUTPUT.KSA;
    T = OUTPUT.T;
    clear INPUT;
    clear OUTPUT;
    
    %---------------------------------------------
    % Test
    %---------------------------------------------
    Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
    Rad = mean(Rad,1);
    testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
    if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
        error
    end
            
    %------------------------------------------
    % Constrain Acceleration 
    %------------------------------------------    
    INPUT.check = 0;
    INPUT.TArr = T;
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESOL = CDESOL;
    INPUT.TST = TST;
    INPUT.type = '3D';
    if strcmp(TST.testing,'Yes');
        N = 1;
    else
        N = 4;
    end
    for n = 1:N
        INPUT.kArr = squeeze(KSA(n,:,:));
        if n == 1
            INPUT.ProfileTest = 'Yes';
        else
            INPUT.ProfileTest = 'No';
        end
        func = str2func([IMETH.accconstfunc,'_Func']);  
        [CACC,err] = func(CACC,INPUT);
        if err.flag == 1
            return
        end
        Tout(n,:) = CACC.TArr;
    end
    clear INPUT;   
    Tout = mean(Tout,1);
  
    %---------------------------------------------
    % Test
    %---------------------------------------------
    testtro = interp1(Rad,Tout,1,'spline'); 
    if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
        error
    end
    
    %---------------------------------------------
    % Determine Initial Radial Speed
    %---------------------------------------------    
    ind = find(Tout > 1,1,'first');
    IMETH.kRadAt1ms = Rad(ind)*PROJdgn.kmax;

    %---------------------------------------------
    % Return
    %--------------------------------------------- 
    ConstEvolT = Tout;
    ConstEvolRad = Rad;
end


%===============================================================================
% Generate Design
%===============================================================================

%----------------------------------------------------
% Generate
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.CLR = CLR;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
if not(strcmp(TST.traj,'All'))
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
clear INPUT;
clear OUTPUT;    

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end      

%------------------------------------------
% Solve T at Evolution Constraint
%------------------------------------------
if strcmp(CACC.doconstraint,'Yes')
    T = interp1(ConstEvolRad,ConstEvolT,Rad,'spline');
end

%---------------------------------------------
% Test
%---------------------------------------------
testtro = interp1(Rad,T,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end


%===============================================================================
% Build
%===============================================================================
% nothing...


%===============================================================================
% TrajSamp
%===============================================================================
func = str2func([IMETH.tsmpfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.SYS = SYS;
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    ErrDisp(err);
    return
end
clear INPUT
PROJimp.dwell = TSMP.dwell;
PROJimp.tro = TSMP.tro;
PROJimp.trajosamp = TSMP.trajosamp;


%===============================================================================
% Recon
%===============================================================================

%---------------------------------------------
% Sample
%---------------------------------------------
SampRecon = (TSMP.sampstart:TSMP.dwell:TSMP.tro);    
sz = size(KSA);
for n = 1:sz(1)
    KmatRecon(n,:,1) = interp1(T,KSA(n,:,1)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
    KmatRecon(n,:,2) = interp1(T,KSA(n,:,2)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
    KmatRecon(n,:,3) = interp1(T,KSA(n,:,3)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
end

%---------------------------------------------
% Visuals
%---------------------------------------------
if strcmp(TST.KVis,'Yes') 
    figure(500);
    subplot(2,3,1);
    plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');

    subplot(2,3,2); 
    Rad = sqrt(KmatRecon(:,:,1).^2 + KmatRecon(:,:,2).^2 + KmatRecon(:,:,3).^2);
    Rad = mean(Rad/PROJdgn.kmax,1);
    ind = find(Rad >= 2*PROJdgn.p,1);
    plot3(KmatRecon(1,1:ind,1)/PROJdgn.kstep,KmatRecon(1,1:ind,2)/PROJdgn.kstep,KmatRecon(1,1:ind,3)/PROJdgn.kstep,'r-');
    
    subplot(2,3,3);
    plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
    
    subplot(2,3,4);
    m = 2:length(KmatRecon(1,:,1));
    kStep = [KmatRecon(:,1,:) KmatRecon(:,m,:) - KmatRecon(:,m-1,:)];
    MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
    MagkStep = mean(MagkStep,1)/PROJdgn.kstep;
    plot(Rad,MagkStep,'r');    

    subplot(2,3,5); hold on;
    plot(SampRecon,KmatRecon(1,:,1)/PROJdgn.kstep,'b*');
    plot(SampRecon,KmatRecon(1,:,2)/PROJdgn.kstep,'g*');
    plot(SampRecon,KmatRecon(1,:,3)/PROJdgn.kstep,'r*');
end    
Kmat = KmatRecon;
samp = SampRecon;
KSMP.nproRecon = length(samp);

sz = size(Kmat);
PROJimp.nproj = sz(1);
PROJimp.npro = sz(2);
PROJimp.meanrelkmax = 1;

%---------------------------------------------
% Test Max Relative Radial Sampling Step
%---------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
KSMP.rRadFirstStepMean = mean(rRad(:,1));
KSMP.rRadSecondStepMean = mean(rRad(:,2)-rRad(:,1));
KSMP.rRadFirstStepMax = max(rRad(:,1));
for n = 2:KSMP.nproRecon
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMP.rRadStepMax = max(rRadStep(:));
KSMP.meanrelkmax = mean(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.maxrelkmax = max(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.rSNR = 1;

%---------------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------------
rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = SampRecon - SampRecon(1);    

%----------------------------------------------------
% Panel
%----------------------------------------------------
% Panel(1,:) = {'npro',KSMP.nproRecon,'Output'};
% Panel(2,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
% Panel(3,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
% Panel(4,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
% Panel(5,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
% Panel(6,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
% Panel(7,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
% Panel(8,:) = {'rSNR',KSMP.rSNR,'Output'};
% PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
% KSMP.PanelOutput = PanelOutput;     

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',IMETH.method,'Output'};
IMETH.Panel = Panel;  

%----------------------------------------------------
% Return
%----------------------------------------------------
IMETH.KSMP = KSMP; 
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.impPROJdgn = PROJdgn;
IMETH.samp = samp;
IMETH.Kmat = Kmat;
IMETH.PROJimp = PROJimp;

Status2('done','',2);
Status2('done','',3);
    
    
