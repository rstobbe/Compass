%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_LRideal_v1h_Func(IMETH,INPUT)

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
TST = INPUT.TST;
PROJdgn = DES.PROJdgn;
DESOL = IMETH.DESOL;
KSMP = IMETH.KSMP;
SPIN = INPUT.DES.SPIN;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
mode = INPUT.mode;
if isfield(INPUT,'PSMP')
    PSMP = INPUT.PSMP;
end
if isfield(INPUT,'TSMP')
    TSMP = INPUT.TSMP;
end
clear INPUT

%---------------------------------------------
% Test for Common Routines
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
    CONSTEV_DESOL = DESOL;                              % make a copy for evolution constraint
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
    clear INPUT;
    clear OUTPUT;
    
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
    
    %------------------------------------------
    % Get radial evolution function for DE solution timing
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.TST = TST;
    INPUT.TST.desoltype = 'ConstEvol';
    func = str2func([IMETH.desoltimfunc,'_Func']);           
    [CONSTEV_DESOL,err] = func(CONSTEV_DESOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;

    %---------------------------------------------
    % Generate Test Trajectories
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.SPIN = SPIN;
    INPUT.DESOL = CONSTEV_DESOL;
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
    INPUT.TArr = T;
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESOL = CONSTEV_DESOL;
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
    IMETH.impPROJdgn = PROJdgn;
    IMETH.PROJimp = PROJimp;
    IMETH.ConstEvolT = Tout;
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
    [DESOL,err] = func(DESOL,INPUT);                            % don't really need to do again - could drop
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
    IMETH.KSA = ORNT.KSA;
    ORNT = rmfield(ORNT,'KSA');
    clear INPUT;
    
    %---------------------------------------------
    % Return
    %---------------------------------------------     
    IMETH.ORNT = ORNT;    
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
    % Delay Start (if necessary)
    %----------------------------------------------------
    Status2('busy','Delay Gradient Start',2);
    func = str2func([IMETH.SysRespfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.qT0 = qT0;
    INPUT.GQKSA0 = GQKSA0;
    INPUT.SYS = SYS;
    INPUT.mode = 'Delay';
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
        fhwfm = figure(1000); 
        fhwfm.Name = 'Gradient Waveforms';
        fhwfm.NumberTitle = 'off';
        fhwfm.Position = [400 150 1000 800];
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
    func = str2func([IMETH.TENDfunc,'_Func']);
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
        for p = 1:length(cartgsteps(1,:,1));
            maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
        end
        maxcartgsteps = smooth(maxcartgsteps,7);
        IMETH.G0wendmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
        sp1 = plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'y-');
        sp2 = plot(qTwend(2:length(qTwend)-2),maxmaggsteps/GQNT.gseg,'y:');
        title('Max Gradient Speed');
        ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        figure(1000); 
        subplot(2,2,3); hold on; 
        for p = 1:length(cartg2drv(1,:,1));
            maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
        end
        maxcartg2drvT = smooth(maxcartg2drvT,7);
        IMETH.G0wendmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;
        plot(qTwend(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'y-');
        title('Max Gradient Channel Acceleration');
        ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
    end     
    
    %----------------------------------------------------
    % Compensate for System Response
    %----------------------------------------------------
    Status2('busy','Compensate for System Response',2);
    func = str2func([IMETH.SysRespfunc,'_Func']);
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
    IMETH.sampend = PROJdgn.tro + SYSRESP.efftrajdel;     

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
    
    %----------------------------------------------------
    % Calculate Relevant Gradient Amplifier Parameters
    %----------------------------------------------------
    Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
    m = (2:length(Gcomp(1,:,1))-2);
    cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
    maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
    cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
    if strcmp(TST.GVis,'Yes') 
        figure(1000); 
        subplot(2,2,2); hold on; 
        for p = 1:length(cartgsteps(1,:,1));
            maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
        end
        maxcartgsteps = smooth(maxcartgsteps,7);
        IMETH.Gcompmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
        sp3 = plot(qTcomp(2:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
        sp4 = plot(qTcomp(2:length(qTcomp)-2),maxmaggsteps/GQNT.gseg,'k:');
        title('Max Gradient Speed');
        ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        legend([sp3,sp4],'Max Channel Speed','Mean Total Speed','Location','southwest');
        subplot(2,2,3); hold on; 
        for p = 1:length(cartg2drv(1,:,1));
            maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
        end
        maxcartg2drvT = smooth(maxcartg2drvT,7);
        IMETH.Gcompmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;
        plot(qTcomp(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'k-');
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
    % Gradient Return
    %----------------------------------------------------
    IMETH.qT = qT;
    IMETH.GQKSA = GQKSA;
    IMETH.Gscnr = Gcomp;
    IMETH.qTscnr = qTcomp;
    IMETH.tgwfm = qTcomp(length(qTcomp));
    IMETH.TstTrj = TST.traj;
    IMETH.GmaxTraj = GmaxTraj;
    IMETH.GmaxSncrChan = GmaxSncrChan;
    
    %----------------------------------------------------
    % Panel Output
    %----------------------------------------------------
    Panel(1,:) = {'GmaxChan (amp)',IMETH.GmaxSncrChan,'Output'};
    Panel(2,:) = {'GmaxChanSlew (amp)',IMETH.Gcompmaxcartslew,'Output'};
    Panel(3,:) = {'GmaxChan2Drv (amp)',IMETH.Gcompmaxcart2drv,'Output'};
    Panel(4,:) = {'kRadAt1ms (1/m)',IMETH.kRadAt1ms,'Output'};
    Panel(5,:) = {'tgwfm',IMETH.tgwfm,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
    IMETH.PanelOutput = PanelOutput;   
    
end

%==================================================================
% Recon
%==================================================================
if strcmp(mode,'Recon')

    %----------------------------------------------------
    % Add Transient Response Effect
    %----------------------------------------------------
    Status2('busy','Include Transient Response Effect',2);
    func = str2func([IMETH.SysRespfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.qT0 = IMETH.qTscnr;
    INPUT.G0 = IMETH.Gscnr;
    INPUT.SYS = SYS;
    INPUT.mode = 'Analyze';
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
    func = str2func([IMETH.kSampfunc,'_Func']);
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
        
        fhk = figure(3000); clf;
        fhk.Name = 'kSpace Sampling';
        fhk.NumberTitle = 'off';
        fhk.Position = [100 150 1400 800];
        subplot(2,3,1); hold on; 
        p1 = plot(Samp0,Kmat0(1,:,1),'k-'); plot(Samp0,Kmat0(1,:,2),'k-'); plot(Samp0,Kmat0(1,:,3),'k-');
        p2 = plot(SampRecon,KmatRecon(1,:,1),'b-'); plot(SampRecon,KmatRecon(1,:,2),'g-'); plot(SampRecon,KmatRecon(1,:,3),'r-');
        p3 = plot(IMETH.qT,IMETH.GQKSA(1,:,1),'b*'); plot(IMETH.qT,IMETH.GQKSA(1,:,2),'g*'); plot(IMETH.qT,IMETH.GQKSA(1,:,3),'r*');
        xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('System Response Compensation Test');
        legend([p1,p2,p3],'Full','Recon','GQKSA','location','southwest');

        subplot(2,3,2); hold on;
        [testK,~] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),IMETH.qT-qTrecon(1),PROJimp.gamma);
        %testK = permute(interp1(SampRecon,permute(KmatRecon,[2 1 3]),IMETH.qT),[2 1 3]);
        Kerr = testK - IMETH.GQKSA;
        maxKerr = squeeze(max(Kerr,[],1));
        plot(IMETH.qT,maxKerr(:,1),'b'); plot(IMETH.qT,maxKerr(:,2),'g'); plot(IMETH.qT,maxKerr(:,3),'r');
        xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('Max TrajComp Error @ qT'); ylim([-0.05 0.05]);
        
        subplot(2,3,3); hold on;
        pts = 50;
        plot(KmatRecon(1,1:pts,1)/PROJdgn.kstep,'b*'); plot(KmatRecon(1,1:pts,2)/PROJdgn.kstep,'g*'); plot(KmatRecon(1,1:pts,3)/PROJdgn.kstep,'r*');    
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
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(ind1,:,1),'k'); plot(Samp0,Kmat0(ind1,:,1),'b');
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(ind2,:,2),'k'); plot(Samp0,Kmat0(ind2,:,2),'g');
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(ind3,:,3),'k'); plot(Samp0,Kmat0(ind3,:,3),'r');
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
    Panel(1,:) = {'troTotal (ms)',KSMP.nproRecon*TSMP.dwell,'Output'};
    Panel(2,:) = {'npro',KSMP.nproRecon,'Output'};
    Panel(3,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
    Panel(4,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
    Panel(5,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
    Panel(6,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
    Panel(7,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
    Panel(8,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
    Panel(9,:) = {'rSNR',KSMP.rSNR,'Output'};
    Panel(10,:) = {'maxkend',KSMP.maxKend,'Output'};
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
    
    
