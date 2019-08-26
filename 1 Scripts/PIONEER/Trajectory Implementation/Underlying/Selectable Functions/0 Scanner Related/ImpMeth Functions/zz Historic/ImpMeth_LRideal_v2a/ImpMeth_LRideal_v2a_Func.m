%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_LRideal_v2a_Func(IMETH,INPUT)

Status2('busy','Implement Ideal LR',2);
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
SPIN = INPUT.DES.SPIN;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
mode = INPUT.mode;
TST = INPUT.TST;
DESOL = IMETH.DESOL;
KSMP = IMETH.KSMP;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
clear INPUT

%---------------------------------------------
% Test for Design Routine
%---------------------------------------------
if not(exist(DES.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(DES.genprojfunc);

%---------------------------------------------
% Update Visualization from Test Function
%---------------------------------------------
KSMP.Vis = TST.KSMP.Vis;
DESOL.Vis = TST.DESOL.Vis;


%==================================================================
% Define Projection Sampling
%==================================================================
if strcmp(mode,'DefProjSamp')
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
end
    
%==================================================================
% Test / Tweak
%==================================================================
if strcmp(mode,'TestTweak')

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

    %------------------------------------------
    % Get radial evolution function for DE solution timing
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.TST = TST;
    INPUT.TST.desoltype = 'FinalSolution';
    INPUT.TST.relprojlenmeas = 'Yes';
    func = str2func([IMETH.desoltimfunc,'_Func']);           
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
        fh = figure(500); clf;
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
        
        button = questdlg('Continue? (Test Solution Fineness for Waveform Generation)');
        if strcmp(button,'No');
            err.flag = 4;
            err.msg = '';
            return
        end    
    end 
    
    %---------------------------------------------
    % Return
    %--------------------------------------------- 
    IMETH.impPROJdgn = PROJdgn;
    IMETH.PROJimp = PROJimp;
    IMETH.ConstEvolT = T;
    IMETH.ConstEvolRad = Rad;
    IMETH.SPIN = SPIN;   
end

%==================================================================
% Generate Design
%==================================================================
if strcmp(mode,'GenDes')

    %------------------------------------------
    % Get radial evolution function for DE solution timing
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.TST = TST;
    INPUT.TST.desoltype = 'FinalSolution';
    func = str2func([IMETH.desoltimfunc,'_Func']);           
    [DESOL,err] = func(DESOL,INPUT);                            
    if err.flag
        return
    end
    clear INPUT;

    %----------------------------------------------------
    % Generate
    %----------------------------------------------------    
    INPUT.PROJdgn = PROJdgn;
    INPUT.SPIN = IMETH.SPIN;
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
    T = interp1(IMETH.ConstEvolRad,IMETH.ConstEvolT,Rad,'spline');
    IMETH.T = T;

    testtro = interp1(Rad,T,1,'spline'); 
    if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
        error
    end
    
    %------------------------------------------
    % Return
    %------------------------------------------
    IMETH.KSA = KSA;
end

%==================================================================
% Build
%==================================================================
if strcmp(mode,'Build')

    %---------------------------------------------
    % Quantize
    %---------------------------------------------
    qT0 = (0:SYS.GradSampBase/1000:PROJdgn.tro);
    GQNT.divno = 1;
    GQNT.mingseg = SYS.GradSampBase/1000;
    GQNT.gseg = SYS.GradSampBase/1000;
    
    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    if qT0(length(qT0)) ~= PROJdgn.tro 
        err.flag = 1;
        err.msg = 'Tro not a multiple of System Gseg';
        return
    end

    %---------------------------------------------
    % Quantize Trajectories
    %---------------------------------------------
    Status2('busy','Quantize Trajectories',2);
    GQKSA0 = Quantize_Projections_v1c(IMETH.T,IMETH.KSA,qT0);

    %---------------------------------------------
    % Test
    %---------------------------------------------
	m = 2:length(GQKSA0(1,:,1));
    kStep = [GQKSA0(:,1,:) GQKSA0(:,m,:) - GQKSA0(:,m-1,:)];
    MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
    MagkStep = mean(MagkStep,1);
    Rad = sqrt(GQKSA0(:,:,1).^2 + GQKSA0(:,:,2).^2 + GQKSA0(:,:,3).^2);
    Rad = mean(Rad,1);
    if round(Rad(end)*1e4) ~= 1e4 && not(strcmp(TST.testspeed,'Rapid'))
        test = round(Rad(end)*1e4)
        error
    end  
    if strcmp(TST.TVis,'Yes')
        figure(500); 
        subplot(2,3,1); 
        plot3(PROJdgn.rad*GQKSA0(1,:,1),PROJdgn.rad*GQKSA0(1,:,2),PROJdgn.rad*GQKSA0(1,:,3),'b-');
        subplot(2,3,2); 
        ind = find(Rad >= 2*PROJdgn.p,1);
        plot3(PROJdgn.rad*GQKSA0(1,1:ind,1),PROJdgn.rad*GQKSA0(1,1:ind,2),PROJdgn.rad*GQKSA0(1,1:ind,3),'b-');
        ploc = interp1(Rad,PROJdgn.rad*squeeze(GQKSA0(1,:,:)),PROJdgn.p,'spline');
        plot3(ploc(1),ploc(2),ploc(3),'rx');
        subplot(2,3,3); 
        plot3(PROJdgn.rad*GQKSA0(1,:,1),PROJdgn.rad*GQKSA0(1,:,2),PROJdgn.rad*GQKSA0(1,:,3),'b-');  
        subplot(2,3,4);
        plot(Rad,PROJdgn.rad*MagkStep,'b');
        subplot(2,3,5); hold on;
        plot(IMETH.T,PROJdgn.rad*IMETH.KSA(1,:,1),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,1),'b*');
        plot(IMETH.T,PROJdgn.rad*IMETH.KSA(1,:,2),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,2),'g*');
        plot(IMETH.T,PROJdgn.rad*IMETH.KSA(1,:,3),'k'); plot(qT0,PROJdgn.rad*GQKSA0(1,:,3),'r*');
        plot(IMETH.T,zeros(size(IMETH.T)),'k:');
        xlabel('(ms)'); ylabel('kSpace (steps)'); title('kSpace Quantization Test');
    end      
    GQKSA0 = PROJdgn.kmax*GQKSA0;
    
    %----------------------------------------------------
    % No Delay
    %----------------------------------------------------
    qT = qT0;
    GQKSA = GQKSA0;
    
    %----------------------------------------------------
    % Solve Gradient Quantization
    %----------------------------------------------------
    Status2('busy','Solve Gradient Quantization',2);
    G0 = SolveGradQuant_v1b(qT,GQKSA,PROJimp.gamma);

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
        figure(500); 
        subplot(2,3,6); hold on; 
        plot(L,zeros(size(L)),'k:');
        plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
        title(['Traj ',num2str(1)]);
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
    end
      
    %----------------------------------------------------
    % Max Sampled Gradient
    %----------------------------------------------------            
    GabsTraj = sqrt(G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2);   
    GmaxTraj = max(GabsTraj(:));
        
    %----------------------------------------------------
    % Gradient Return
    %----------------------------------------------------
    IMETH.qT = qT;
    IMETH.GQKSA = GQKSA;
    IMETH.Gscnr = G0;
    IMETH.qTscnr = qT;
    IMETH.G0 = G0;
    IMETH.GmaxTraj = GmaxTraj;
    
    %----------------------------------------------------
    % Panel Output
    %----------------------------------------------------
    Panel(1,:) = {'GmaxTramp (mT/m)',IMETH.GmaxTraj,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
    IMETH.PanelOutput = PanelOutput;    
end


%==================================================================
% TrajSamp
%==================================================================
if strcmp(mode,'TrajSamp')
    func = str2func([IMETH.tsmpfunc,'_Func']);
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.GWFM = IMETH;
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
    IMETH.PROJimp = PROJimp;
    IMETH.TSMP = TSMP;
end


%==================================================================
% Recon
%==================================================================
if strcmp(mode,'Recon')

    %----------------------------------------------------
    % No Transient Response Effect
    %----------------------------------------------------
    Grecon = IMETH.G0;  
    qTrecon = IMETH.qT;
    
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
        figure(500); 
        subplot(2,3,6); hold on; 
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
    func = str2func([IMETH.kSampfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.qTrecon = qTrecon;
    INPUT.Grecon = Grecon;
    INPUT.TSMP = TSMP;
    INPUT.SYS = SYS;
    [KSMP,err] = func(KSMP,INPUT);
    if err.flag
        return
    end  
    SampRecon = KSMP.SampRecon;  
    KmatRecon = KSMP.KmatRecon;   
    Kend = KSMP.Kend;  
      
    %---------------------------------------------
    % Visuals
    %---------------------------------------------
    if strcmp(TST.KVis,'Yes') 
        figure(500);
        subplot(2,3,1);
        plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
        lim = PROJdgn.rad;
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[-31 -39 12.5]); 
        
        subplot(2,3,2); 
        Rad = sqrt(KmatRecon(:,:,1).^2 + KmatRecon(:,:,2).^2 + KmatRecon(:,:,3).^2);
        Rad = mean(Rad/PROJdgn.kmax,1);
        ind = find(Rad >= 2*PROJdgn.p,1);
        plot3(KmatRecon(1,1:ind,1)/PROJdgn.kstep,KmatRecon(1,1:ind,2)/PROJdgn.kstep,KmatRecon(1,1:ind,3)/PROJdgn.kstep,'r-');
        lim = ceil(PROJdgn.rad*2*PROJdgn.p);
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[-31 -39 12.5]); 
        
        subplot(2,3,3);
        plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
        lim = 0.5;
        xlim([-lim,lim]); ylim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[0 0 5000]);
        set(gca,'CameraTargetMode','manual');
        set(gca,'CameraTarget',[0 0 0]);
        set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5));    

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

    %---------------------------------------------
    % Return Sampling Timing for Testing
    %---------------------------------------------
    rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
    KSMP.rKmag = mean(rKmag,1);
    KSMP.tatr = SampRecon - SampRecon(1);    
    
    %----------------------------------------------------
    % Other
    %----------------------------------------------------
    KSMP.maxfreq = IMETH.GmaxTraj*PROJimp.gamma*PROJdgn.fov/2;
    KSMP.samp = samp;
    KSMP.Kmat = Kmat;
    KSMP.Kend = Kend;
    KSMP.maxKend = maxKend;   
    
    %----------------------------------------------------
    % Panel
    %----------------------------------------------------
    Panel(1,:) = {'npro',KSMP.nproRecon,'Output'};
    Panel(2,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
    Panel(3,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
    Panel(4,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
    Panel(5,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
    Panel(6,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
    Panel(7,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
    Panel(8,:) = {'rSNR',KSMP.rSNR,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
    KSMP.PanelOutput = PanelOutput;     
 
    %----------------------------------------------------
    % Return
    %----------------------------------------------------
    KSMP = rmfield(KSMP,{'Samp0','Kmat0','SampRecon','KmatRecon'});
    IMETH.KSMP = KSMP;    
    
end




Status2('done','',2);
Status2('done','',3);
    
    
