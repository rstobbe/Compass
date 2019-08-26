%=====================================================
%  
%
%=====================================================

function [IMETH,err] = ImpMeth_YarnBall_v1b_Func(IMETH,INPUT)

Status('busy','Implement Yarnball');

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
if not(strcmp(INPUT.DES.type,'YB'))
    err.flag = 1;
    err.msg = '''ImpMeth_YarnBall'' is not valid for the trajectory design';
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
ORNT = IMETH.ORNT;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
IMPTYPE = IMETH.IMPTYPE;
DESOL = IMETH.DESOL;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
CACC = IMETH.CACC;
TEND = IMETH.TEND;
SYSRESP = IMETH.SYSRESP;
KSMP = IMETH.KSMP;
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
if strcmp(IMETH.vis,'basic')
    KSMP.Vis = 'No';
    DESOL.Vis = 'No';
    CACC.Vis = 'No';
    SYSRESP.Vis = 'No'; 
    TST.GVis = 'No';
    TST.KVis = 'No';    
    TST.TVis = 'No';  
elseif strcmp(IMETH.vis,'gslew')
    KSMP.Vis = 'No';
    DESOL.Vis = 'No';
    CACC.Vis = 'ProfOnly';
    SYSRESP.Vis = 'No'; 
    TST.GVis = 'Yes';
    TST.KVis = 'No';    
    TST.TVis = 'No';     
else
    KSMP.Vis = TST.KSMP.Vis;
    DESOL.Vis = TST.DESOL.Vis;
    CACC.Vis = TST.CACC.Vis;
    SYSRESP.Vis = TST.SYSRESP.Vis;
end
    
CDESOL = DESOL;                 % copy for evolution constraint

%===============================================================================
% Define Projection Sampling
%===============================================================================
func = str2func([PSMP.method,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
INPUT.SPIN = DES.SPIN;
INPUT.testing = 'No';    
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
func = str2func([SPIN.method,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
if SPIN.p ~= PROJdgn.p
    error
end

%------------------------------------------
% Do ImpType Things
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.SPIN = SPIN;
INPUT.CLR = CLR;
INPUT.loc = 'PreDeSolTim';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.IMPTYPE = IMPTYPE;
if strcmp(TST.testspeed,'rapid')
    INPUT.courseadjust = 'yes';    
else
    INPUT.courseadjust = 'no';
end
func = str2func([DESOL.method,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
T = DESOL.T;
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Do ImpType Things
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
if strcmp(TST.traj,'All') 
    INPUT.PSMP.phi = PSMP.phi(1);
    INPUT.PSMP.theta = PSMP.theta(1);
elseif strcmp(TST.traj,'TestSet')
    INPUT.PSMP.phi = 0;
    INPUT.PSMP.theta = 0;
else
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.loc = 'PreGeneration';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Test Solution Fineness
%----------------------------------------------------    
INPUT.IMPTYPE = IMPTYPE;
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
clear INPUT;
clear OUTPUT;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)   
    figure(1234123);
    plot(T,Rad,'-*');
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

%---------------------------------------------
% Measure TrajLength
%---------------------------------------------
ind = find(Rad >= 1,1);
IMETH.TrajLen = sum(MagkStep(1:ind));

%---------------------------------------------
% Plot
%---------------------------------------------
if strcmp(TST.TVis,'Yes')
    fh = figure(500);
    if strcmp(fh.NumberTitle,'on')
        fh.Name = 'Solution Fineness Testing for Waveform Generation';
        fh.NumberTitle = 'off';
        fh.Position = [200 150 1400 800];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fh);
        end
    end  
    subplot(2,3,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),1,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'bx');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = max(Rad)*PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Full Trajectory');
    set(gca,'cameraposition',[-310 -390 125]); 
    
    subplot(2,3,2); hold on; axis equal; grid on; box off;
    ind = find(Rad >= 1.25*PROJdgn.p,1);  
    if isempty(ind)
        ind = length(Rad);
    end
    plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),1,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'bx');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = ceil(PROJdgn.rad*Rad(ind));
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Initial Portion');
    set(gca,'cameraposition',[-310 -390 125]); 

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
    plot([0 2],[0.1 0.1],':');
    plot([0 2],[1 1],':');
    ylim([0 1.1]);
    xlabel('Relative Radius'); ylabel('kStep'); xlim([0 max(Rad)]); title('Solution Sampling Fineness');
    
    test = 1;
    if isfield(TST,'checks')
        if strcmp(TST.checks,'No')
            test = 0;
        end
    end
    if test == 1
        button = questdlg('Continue? (Check Solution Fineness for Waveform Generation)');
        if strcmp(button,'No')
            err.flag = 4;
            err.msg = '';
            return
        end
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
    INPUT.IMPTYPE = IMPTYPE;
    INPUT.courseadjust = 'yes';    
    func = str2func([CDESOL.method,'_Func']);           
    [CDESOL,err] = func(CDESOL,INPUT);
    if err.flag
        return
    end
    T = CDESOL.T;
    clear INPUT;

    %------------------------------------------
    % Do ImpType Things
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESOL = CDESOL;
    INPUT.CLR = CLR;
    if strcmp(TST.traj,'All') || strcmp(TST.traj,'TestSet')
        INPUT.PSMP.phi = [0,pi/4,pi/2,3*pi/4];
        INPUT.PSMP.theta = [0,0,0,0];
    else
        INPUT.PSMP.phi = PSMP.phi(TST.traj);
        INPUT.PSMP.theta = PSMP.theta(TST.traj);
    end
    INPUT.loc = 'PreGeneration';
    func = str2func([IMPTYPE.method,'_Func']);           
    [IMPTYPE,err] = func(IMPTYPE,INPUT);
    if err.flag
        return
    end
    clear INPUT;    
    
    %---------------------------------------------
    % Generate Test Trajectories
    %---------------------------------------------
    INPUT.IMPTYPE = IMPTYPE;
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
    testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
    if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)
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
    sz = size(KSA);
    if sz(1) > 4
        error
    end
    for n = 1:sz(1)
        INPUT.kArr = squeeze(KSA(n,:,:));
        if n == 1
            INPUT.ProfileTest = 'Yes';
        else
            INPUT.ProfileTest = 'No';
        end
        func = str2func([CACC.method,'_Func']);  
        [CACC,err] = func(CACC,INPUT);
        if err.flag ~= 0
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
    GWFM.kRadAt1ms = Rad(ind)*PROJdgn.kmax;
    ind = find(Tout > 0.3,1,'first');
    GWFM.kRadAt03ms = Rad(ind)*PROJdgn.kmax;
    
    %---------------------------------------------
    % Return
    %--------------------------------------------- 
    ConstEvolT = Tout;
    ConstEvolRad = Rad;
end


%===============================================================================
% Generate Design
%===============================================================================

%------------------------------------------
% Do ImpType Things
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.CLR = CLR;
if strcmp(TST.traj,'All')
    INPUT.PSMP = PSMP;    
elseif strcmp(TST.traj,'TestSet')
    INPUT.PSMP = PSMP;  
    INPUT.PSMP.phi = [0,pi/4,pi/2,3*pi/4];
    INPUT.PSMP.theta = [0,0,0,0];
else
    INPUT.PSMP = PSMP;
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.loc = 'PreGeneration';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Generate 
%----------------------------------------------------   
INPUT.IMPTYPE = IMPTYPE;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
EndVals = OUTPUT.EndVals;
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

%----------------------------------------------------
% Return to k=0 Solution
%---------------------------------------------------- 
if IMPTYPE.solutions == 2

    %------------------------------------------
    % Do ImpType Things
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESOL = DESOL;
    INPUT.CLR = CLR;
    INPUT.StartVals = EndVals;
    INPUT.loc = 'PreGeneration2';
    func = str2func([IMPTYPE.method,'_Func']);           
    [IMPTYPE,err] = func(IMPTYPE,INPUT);
    if err.flag
        return
    end
    clear INPUT;    

    %----------------------------------------------------
    % Generate 
    %----------------------------------------------------   
    INPUT.IMPTYPE = IMPTYPE;
    [OUTPUT,err] = genprojfunc(INPUT);
    if err.flag
        return
    end
    KSA2 = OUTPUT.KSA;
    clear INPUT;
    clear OUTPUT;  

    %---------------------------------------------
    % Test
    %---------------------------------------------
    Rad2 = sqrt(KSA2(:,:,1).^2 + KSA2(:,:,2).^2 + KSA2(:,:,3).^2);
    Rad2 = mean(Rad2,1);

    %------------------------------------------
    % Solve T at Evolution Constraint
    %------------------------------------------
    if strcmp(CACC.doconstraint,'Yes')
        T2 = interp1(ConstEvolRad,ConstEvolT,Rad2,'spline');
    end
    T2 = 2*T(end)-T2;
    %figure(3457345); hold on;
    %plot(T,Rad,'b');
    %plot(T2,Rad2,'r');    
    %plot(T2,Rad2,'g');
    
    %---------------------------------------------
    % Combine
    %---------------------------------------------
    T = [T T2];
    KSA = cat(2,KSA,KSA2);
    %figure(2346234);
    %plot(T);
end

%---------------------------------------------
% Plot
%---------------------------------------------
figure(500);
subplot(2,3,1); 
plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');

%------------------------------------------
% Orient
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.KSA = KSA;
INPUT.SYS = SYS;
func = str2func([IMETH.orientfunc,'_Func']);           
[ORNT,err] = func(ORNT,INPUT);
if err.flag
    return
end
clear INPUT;
KSA = ORNT.KSA;
ORNT = rmfield(ORNT,'KSA');


%===============================================================================
% Build
%===============================================================================

%---------------------------------------------
% Quantize
%---------------------------------------------
wfmend = T(end);
%qT0 = (0:SYS.GradSampBase/1000:PROJdgn.tro);
qT0 = (0:SYS.GradSampBase/1000:wfmend);
GQNT.divno = 1;
GQNT.mingseg = SYS.GradSampBase/1000;
GQNT.gseg = SYS.GradSampBase/1000;

%---------------------------------------------
% Test Quantization
%---------------------------------------------
ind = find(qT0 == PROJdgn.tro);
if ind == 0
    err.flag = 1;
    err.msg = 'Tro not a multiple of System Gseg';
    return
end

%---------------------------------------------
% Quantize Trajectories
%---------------------------------------------
Status2('busy','Quantize Trajectories',2);
GQKSA0 = Quantize_Projections_v1c(T,KSA,qT0);

%------------------------------------------
% Do ImpType Things
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.KSA = GQKSA0;
INPUT.T = qT0;
INPUT.loc = 'PostGeneration';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
GQKSA0 = IMPTYPE.KSA;
qT0 = IMPTYPE.T;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(GQKSA0(:,:,1).^2 + GQKSA0(:,:,2).^2 + GQKSA0(:,:,3).^2);
Rad = mean(Rad,1);
if strcmp(TST.TVis,'Yes')
    figure(500); 
    subplot(2,3,1); 
    plot3(PROJdgn.rad*GQKSA0(1,:,1),PROJdgn.rad*GQKSA0(1,:,2),PROJdgn.rad*GQKSA0(1,:,3),'k-');
    subplot(2,3,2); 
    ind = find(Rad >= 2*PROJdgn.p,1);
    plot3(PROJdgn.rad*GQKSA0(1,1:ind,1),PROJdgn.rad*GQKSA0(1,1:ind,2),PROJdgn.rad*GQKSA0(1,1:ind,3),'b-');
    subplot(2,3,3); 
    plot3(PROJdgn.rad*GQKSA0(1,:,1),PROJdgn.rad*GQKSA0(1,:,2),PROJdgn.rad*GQKSA0(1,:,3),'b-');  
    subplot(2,3,5); hold on;
    plot(T,PROJdgn.rad*KSA(1,:,1),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,1),'b*');
    plot(T,PROJdgn.rad*KSA(1,:,2),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,2),'g*');
    plot(T,PROJdgn.rad*KSA(1,:,3),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,3),'r*');
    plot(qT0,zeros(size(qT0)),'k:');
    xlabel('(ms)'); ylabel('kSpace (steps)'); title('kSpace Test');
end      
GQKSA0 = PROJdgn.kmax*GQKSA0;

%----------------------------------------------------
% Delay Start (if necessary)
%----------------------------------------------------
Status2('busy','Delay Gradient Start',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qT0;
INPUT.GQKSA0 = GQKSA0;
INPUT.SYS = SYS;
INPUT.mode = 'Delay';
INPUT.TST = TST;
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
qT = SYSRESP.qT;
GQKSA = SYSRESP.GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status2('busy','Solve Gradient Quantization',2);
G0 = SolveGradQuant_v1c(qT,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qT)-1
        L((n-1)*2+1) = qT(n);
        L(n*2) = qT(n+1);
        Gvis(:,(n-1)*2+1,:) = G0(:,n,:);
        Gvis(:,n*2,:) = G0(:,n,:);
    end
    fhwfm = figure(1000); 
    if strcmp(fhwfm.NumberTitle,'on')
        fhwfm.Name = 'Gradient Waveforms';
        fhwfm.NumberTitle = 'off';
        fhwfm.Position = [400 150 1000 800];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fhwfm);
        end
    end  
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%---------------------------------------------
% Calculate Gradient Momoments
%---------------------------------------------
Gmom = sum(G0,2)*(SYS.GradSampBase/1000);
Gend = G0(:,end,:);   

%----------------------------------------------------
% End Trajectory
%----------------------------------------------------
Status2('busy','End Trajectory',2);
func = str2func([TEND.method,'_Func']);
INPUT.SYS = SYS;
INPUT.Gmom = Gmom;  
INPUT.Gend = Gend;
INPUT.PROJimp = PROJimp;
INPUT.PROJdgn = PROJdgn;
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end    
Gend = TEND.Gend;
G0wend = cat(2,G0,Gend);
qTend = (GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
qTwend = [qT qT(end)+qTend];

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0wend);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTwend)-1
        L((n-1)*2+1) = qTwend(n);
        L(n*2) = qTwend(n+1);
        Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
        Gvis(:,n*2,:) = G0wend(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(G0wend(1,:,1))-2);
cartgsteps = [G0wend(:,1,:) G0wend(:,m,:)-G0wend(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    for p = 1:length(cartgsteps(1,:,1))
        maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
    end
    maxcartgsteps = smooth(maxcartgsteps,7);
    GWFM.G0wendmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
    plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'y-');
    plot(qTwend(2:length(qTwend)-2),maxmaggsteps/GQNT.gseg,'y:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    figure(1000); 
    subplot(2,2,3); hold on; 
    for p = 1:length(cartg2drv(1,:,1))
        maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
    end
    maxcartg2drvT = smooth(maxcartg2drvT,7);
    GWFM.G0wendmaxcart2drv = max(maxcartg2drvT(2:length(qT)-2))/GQNT.gseg^2;
    plot(qTwend(2:length(qT)-2),maxcartg2drvT(2:length(qT)-2)/GQNT.gseg^2,'y-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end     

%----------------------------------------------------
% Compensate for System Response
%----------------------------------------------------
Status2('busy','Compensate for System Response',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qTwend;
INPUT.G0 = G0wend;
INPUT.SYS = SYS;
INPUT.mode = 'Compensate';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
Gcomp = SYSRESP.Gcomp;    
qTcomp = SYSRESP.Tcomp;
GWFM.sampend = PROJdgn.tro + SYSRESP.efftrajdel;     

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Gcomp);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTcomp)-1
        L((n-1)*2+1) = qTcomp(n);
        L(n*2) = qTcomp(n+1);
        Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
        Gvis(:,n*2,:) = Gcomp(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end    

%----------------------------------------------------
% Calculate Acoustic Frequency Response
%----------------------------------------------------    
if strcmp(TST.GVis,'Yes') 
    Glen = length(Gcomp(1,:,1));
    zfGcompX = zeros(1,10000);
    zfGcompY = zeros(1,10000);
    zfGcompZ = zeros(1,10000);    
    zfGcompX(1:Glen) = squeeze(Gcomp(1,:,1)); 
    zfGcompY(1:Glen) = squeeze(Gcomp(1,:,2)); 
    zfGcompZ(1:Glen) = squeeze(Gcomp(1,:,3));     
    ftGcompX = abs(fftshift(fft(zfGcompX)));
    ftGcompY = abs(fftshift(fft(zfGcompY)));
    ftGcompZ = abs(fftshift(fft(zfGcompZ)));    
    figure(1000); 
    subplot(2,2,4); hold on; 
    fstep = 1/(10000*GQNT.gseg);
    freq = (-1/(2*GQNT.gseg):fstep:(1/(2*GQNT.gseg))-fstep);
    freq = freq*1000;
    RefSin = 30*sin(1000*2*pi*qTcomp(1:end-1)/1000);
    zfRefSin = zeros(1,10000);
    zfRefSin(1:Glen) = RefSin;
    ftRefSin = abs(fftshift(fft(zfRefSin)));
    plot(freq,ftRefSin/max(ftRefSin(:)),'k');
    plot(freq,ftGcompX/max(ftRefSin(:)),'b-'); plot(freq,ftGcompY/max(ftRefSin(:)),'g-'); plot(freq,ftGcompZ/max(ftRefSin(:)),'r-');    
    title('Acoustic Resonance (Relative to 30 mT/m Sinusoid at 1000 Hz)');
    xlabel('(Hz)','fontsize',10,'fontweight','bold');
    ylabel('Relative Magnitude','fontsize',10,'fontweight','bold');
    xlim([0 2000]);
    plot([SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2)],[0 1],'k:');
end
    
%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(Gcomp(1,:,1))-2);
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
for p = 1:length(cartgsteps(1,:,1))
    maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
end
maxcartgsteps = smooth(maxcartgsteps,7);
GWFM.Gcompmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
for p = 1:length(cartg2drv(1,:,1))
    maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
end
maxcartg2drvT = smooth(maxcartg2drvT,7);
GWFM.Gcompmaxcart2drv = max(maxcartg2drvT(2:length(qT)-2))/GQNT.gseg^2;

if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    sp3 = plot(qTcomp(2:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
    sp4 = plot(qTcomp(2:length(qTcomp)-2),maxmaggsteps/GQNT.gseg,'k:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    legend([sp3,sp4],'Max Channel Speed','Mean Total Speed','Location','southwest');
    
    subplot(2,2,3); hold on; 
    plot(qTcomp(2:length(qT)-2),maxcartg2drvT(2:length(qT)-2)/GQNT.gseg^2,'k-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end     

%----------------------------------------------------
% Gradient Abs Test
%----------------------------------------------------    
GmaxSncrChan = max(abs(Gcomp(:)));

%----------------------------------------------------
% Max Sampled Gradient
%----------------------------------------------------            
GabsTraj = sqrt(G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2);   
GmaxTraj = max(GabsTraj(:));

%----------------------------------------------------
% Save
%----------------------------------------------------
GWFM.TstTrj = TST.traj;
GWFM.GmaxTraj = GmaxTraj;
GWFM.GmaxSncrChan = GmaxSncrChan;
GWFM.tgwfm = qTcomp(length(qTcomp));
IMETH.Gscnr = Gcomp;
IMETH.qTscnr = qTcomp;
IMETH.tgwfm = GWFM.tgwfm;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
GwfmPanel(1,:) = {'GmaxChan (amp)',GWFM.GmaxSncrChan,'Output'};
GwfmPanel(2,:) = {'GmaxChanSlew (amp)',GWFM.Gcompmaxcartslew,'Output'};
GwfmPanel(3,:) = {'GmaxChan2Drv (amp)',GWFM.Gcompmaxcart2drv,'Output'};
GwfmPanel(4,:) = {'kRadAt1ms (1/m)',GWFM.kRadAt1ms,'Output'};
GwfmPanel(5,:) = {'kRadAt03ms (1/m)',GWFM.kRadAt03ms,'Output'};
GwfmPanel(6,:) = {'TrajLen (relative)',IMETH.TrajLen,'Output'};
GwfmPanel(7,:) = {'tgwfm (ms)',IMETH.tgwfm,'Output'};


%===============================================================================
% TrajSamp
%===============================================================================
func = str2func([TSMP.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.GWFM = GWFM;
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
PROJimp.npro = TSMP.npro;


%===============================================================================
% Recon
%===============================================================================

%----------------------------------------------------
% Add Transient Response Effect
%----------------------------------------------------
Status2('busy','Include Transient Response Effect',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = IMETH.qTscnr;
INPUT.G0 = IMETH.Gscnr;
INPUT.SYS = SYS;
INPUT.mode = 'Analyze';
INPUT.TST = TST;
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
Grecon = SYSRESP.Grecon;  
qTrecon = SYSRESP.Trecon;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Grecon);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTrecon)-1
        L((n-1)*2+1) = qTrecon(n);
        L(n*2) = qTrecon(n+1);
        Gvis(:,(n-1)*2+1,:) = Grecon(:,n,:);
        Gvis(:,n*2,:) = Grecon(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    xlim([L(1) L(end)]);
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
Status2('busy','Resample k-Space',2);
func = str2func([KSMP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qTrecon = qTrecon;
INPUT.Grecon = Grecon;
INPUT.TSMP = TSMP;
INPUT.SYSRESP = SYSRESP;
INPUT.SYS = SYS;
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
Samp0 = KSMP.Samp0;  
Kmat0 = KSMP.Kmat0;    
SampRecon = KSMP.SampRecon;  
KmatRecon = KSMP.KmatRecon;   
Kend = KSMP.Kend;  
KSMP = rmfield(KSMP,{'Samp0','Kmat0','SampRecon','KmatRecon','Kend'}); 

%------------------------------------------
% Do ImpType Things
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.Samp0 = Samp0;
INPUT.Kmat0 = Kmat0;
INPUT.SampRecon = SampRecon;
INPUT.KmatRecon = KmatRecon;
INPUT.qTrecon = qTrecon;
INPUT.Grecon = Grecon;
INPUT.KSMP = KSMP;
INPUT.TSMP = TSMP;
INPUT.loc = 'PostResample';
func = str2func([IMPTYPE.method,'_Func']);           
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
KmatRecon = IMPTYPE.KmatRecon;
KmatDisplay = IMPTYPE.KmatDisplay;
KSMP = IMPTYPE.KSMP;
TSMP = IMPTYPE.TSMP;

%---------------------------------------------
% Visuals
%---------------------------------------------
if strcmp(TST.KVis,'Yes') 
    figure(500);
    subplot(2,3,1);
    clrarr = {'r','b','g'};
    for n = 1:IMPTYPE.numberofimages
        plot3(KmatDisplay(:,1,n)/PROJdgn.kstep,KmatDisplay(:,2,n)/PROJdgn.kstep,KmatDisplay(:,3,n)/PROJdgn.kstep,clrarr{n},'linewidth',2);
    end
    subplot(2,3,2); 
    Rad = sqrt(KmatRecon(:,:,1,1).^2 + KmatRecon(:,:,2,1).^2 + KmatRecon(:,:,3,1).^2);
    Rad = mean(Rad/PROJdgn.kmax,1);
    ind = find(Rad >= 2*PROJdgn.p,1);
    plot3(KmatRecon(1,1:ind,1,1)/PROJdgn.kstep,KmatRecon(1,1:ind,2,1)/PROJdgn.kstep,KmatRecon(1,1:ind,3,1)/PROJdgn.kstep,'r-');
    subplot(2,3,3);
    plot3(KmatRecon(1,:,1,1)/PROJdgn.kstep,KmatRecon(1,:,2,1)/PROJdgn.kstep,KmatRecon(1,:,3,1)/PROJdgn.kstep,'r-');

    fhk = figure(3000); clf;
    if strcmp(fhk.NumberTitle,'on')
        fhk.Name = 'kSpace Sampling';
        fhk.NumberTitle = 'off';
        fhk.Position = [100 150 1400 800];
    else
        redraw = 1;
        if isfield(TST,'redraw')
            if strcmp(TST.redraw,'No')
                redraw = 0;
            end
        end
        if redraw == 1
            clf(fhk);
        end
    end
    subplot(2,3,1); hold on; 
    plot(Samp0,Kmat0(1,:,1),'k-'); plot(Samp0,Kmat0(1,:,2),'k-'); plot(Samp0,Kmat0(1,:,3),'k-');
    for n = 1:IMPTYPE.numberofimages
        plot(Samp0,KmatDisplay(:,1,n),clrarr{n},'linewidth',2); 
        plot(Samp0,KmatDisplay(:,2,n),clrarr{n},'linewidth',2); 
        plot(Samp0,KmatDisplay(:,3,n),clrarr{n},'linewidth',2);
    end
    xlim([0 IMETH.tgwfm]);
    xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('System Response Compensation Test');

    subplot(2,3,2); hold on;
    Status2('busy','Test k-Space Error',2);
    [testK,~] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),qT-qTrecon(1),PROJimp.gamma);
    %testK = permute(interp1(SampRecon,permute(KmatRecon,[2 1 3]),qT),[2 1 3]);
    Kerr = testK - GQKSA;
    maxKerr = squeeze(max(Kerr,[],1));
    plot(qT,maxKerr(:,1),'b'); plot(qT,maxKerr(:,2),'g'); plot(qT,maxKerr(:,3),'r');
    xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('Max TrajComp Error @ qT'); ylim([-0.05 0.05]);

    subplot(2,3,3); hold on;
    pts = 50;
    plot(KmatRecon(1,1:pts,1,1)/PROJdgn.kstep,'b*'); plot(KmatRecon(1,1:pts,2,1)/PROJdgn.kstep,'g*'); plot(KmatRecon(1,1:pts,3,1)/PROJdgn.kstep,'r*');    
    xlim([0 pts]);
    xlabel('Sampling Points'); ylabel('kSpace Steps'); title('Initial Sampled Points');

    subplot(2,3,4); hold on;
    if length(Kend(:,1,1)) == 1
        plot(Kend(:,1,1),'b*'); plot(Kend(:,1,2),'g*'); plot(Kend(:,1,3),'r*');
    else
        plot(Kend(:,1,1),'b'); plot(Kend(:,1,2),'g'); plot(Kend(:,1,3),'r');
    end
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Trajectory End');

    subplot(2,3,5); hold on;
    ind1 = find(abs(Kend(:,1,1)) == max(abs(Kend(:,1,1))));
    ind2 = find(abs(Kend(:,1,2)) == max(abs(Kend(:,1,2))));
    ind3 = find(abs(Kend(:,1,3)) == max(abs(Kend(:,1,3))));
    plot(T,PROJdgn.kmax*KSA(ind1,:,1),'k'); plot(Samp0,Kmat0(ind1,:,1),'b');
    plot(T,PROJdgn.kmax*KSA(ind2,:,2),'k'); plot(Samp0,Kmat0(ind2,:,2),'g');
    plot(T,PROJdgn.kmax*KSA(ind3,:,3),'k'); plot(Samp0,Kmat0(ind3,:,3),'r');
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Waveforms with Greatest kEnd');
end    
Kmat = KmatRecon;
samp = SampRecon;

%---------------------------------------------
% Test
%---------------------------------------------
maxKend = max(abs(Kend(:)));    

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
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;

%---------------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------------
rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = SampRecon - SampRecon(1);    

%----------------------------------------------------
% Other
%----------------------------------------------------
KSMP.maxfreq = GWFM.GmaxTraj*PROJimp.gamma*PROJdgn.fov/2;
IMETH.samp = samp;
IMETH.Kmat = Kmat;
IMETH.Kend = Kend;
KSMP.maxKend = maxKend;   

%----------------------------------------------------
% Panel
%----------------------------------------------------
KsmpPanel(1,:) = {'troTotal (ms)',KSMP.nproRecon*TSMP.dwell,'Output'};
KsmpPanel(2,:) = {'npro',KSMP.nproRecon,'Output'};
KsmpPanel(3,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
KsmpPanel(4,:) = {'ImageDelay (ms)',KSMP.Delay2Centre,'Output'};

PanelSpace(1,:) = {'','','Output'};
if strcmp(IMETH.vis,'basic') || strcmp(IMETH.vis,'gslew')
    IMETH.Panel = [PanelSpace;GwfmPanel];
else
    IMETH.Panel = [PanelSpace;GwfmPanel;PanelSpace;TSMP.Panel;PanelSpace;KsmpPanel];
end

%----------------------------------------------------
% Basic Figure
%----------------------------------------------------
fh = figure(23457); 
if strcmp(fh.NumberTitle,'on')
    fh.Name = 'Waveform Display';
    fh.NumberTitle = 'off';
    fh.Position = [250 300 1400 400];
else
    redraw = 1;
    if isfield(TST,'redraw')
        if strcmp(TST.redraw,'No')
            redraw = 0;
        end
    end
    if redraw == 1
        clf(fh);
    end
end  
subplot(1,3,1); hold on; axis equal; grid on; box off;
set(gca,'cameraposition',[-400 -500 80]); 
clrarr = {'r','b','g'};
plot3(KmatDisplay(:,1,end),KmatDisplay(:,2,end),KmatDisplay(:,3,end),'k-');
for n = 1:IMPTYPE.numberofimages
    plot3(KmatDisplay(:,1,n),KmatDisplay(:,2,n),KmatDisplay(:,3,n),clrarr{n},'linewidth',2);
end
xlabel('k_x (1/m)'); ylabel('k_y (1/m)'); zlabel('k_z (1/m)'); title('Final Trajectory');

subplot(1,3,2); hold on;
for n = 1:1:IMPTYPE.numberofimages
    plot(samp,Kmat(1,:,1,n),'b');
    plot(samp,Kmat(1,:,2,n),'g');
    plot(samp,Kmat(1,:,3,n),'r');
end
plot([0 samp(end)],[0 0],':');
xlim([0,samp(end)]);
lim = PROJdgn.kmax;
ylim([-lim,lim]);
xlabel('time (ms)');
ylabel('k (1/m)');
title('Final kSpace Samplings');

subplot(1,3,3); hold on;
[A,B,C] = size(IMETH.Gscnr);
Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
for n = 1:length(IMETH.qTscnr)-1
    L((n-1)*2+1) = IMETH.qTscnr(n);
    L(n*2) = IMETH.qTscnr(n+1);
    Gvis(:,(n-1)*2+1,:) = IMETH.Gscnr(:,n,:);
    Gvis(:,n*2,:) = IMETH.Gscnr(:,n,:);
end
plot(L,Gvis(1,:,1),'b');
plot(L,Gvis(1,:,2),'g');
plot(L,Gvis(1,:,3),'r');
plot([0 IMETH.tgwfm],[0 0],':');
xlim([0,IMETH.tgwfm]);
lim = GWFM.GmaxTraj;
ylim([-lim,lim]);
xlabel('time (ms)');
ylabel('Gradient (mT/m)');
title('Gradient Waveform');

%----------------------------------------------------
% Testing
%----------------------------------------------------
if isfield(TST,'savelots')
    if strcmp(TST.savelots,'Yes')
        KSMP.ExtraSave.Samp0 = Samp0;
        KSMP.ExtraSave.Kmat0 = Kmat0;
        KSMP.ExtraSave.KmatDisplay = KmatDisplay;
    end
end

%----------------------------------------------------
% Return
%----------------------------------------------------
GWFM.ORNT = ORNT;
IMETH.GWFM = GWFM; 
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.KSMP = KSMP;
IMETH.impPROJdgn = PROJdgn;
IMETH.PROJimp = PROJimp;
IMETH.RADEV = DESOL.RADEV;

Status2('done','',2);
Status2('done','',3);
    
    
