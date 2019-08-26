%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_LRstandard_v1e_Func(IMETH,INPUT)

Status2('busy','Implement Standard 3D Looping Radial',2);
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
ORNT = IMETH.ORNT;
DESOL = IMETH.DESOL;
CACC = IMETH.CACC;
TEND = IMETH.TEND;
SYSRESP = IMETH.SYSRESP;
SPIN = INPUT.DES.SPIN;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
testing = INPUT.testing;
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
%--- update
DES.genprojfunc = 'LR1_GenProj_v1h';
%---
if not(exist(DES.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(DES.genprojfunc);

%------------------------------------------
% Testing
%------------------------------------------
TstTrj = 750;
if strcmp(testing,'Rapid')
    TST.testing = 'Yes';
    TST.testspeed = 'Rapid';
    TST.traj = TstTrj;
elseif  strcmp(testing,'RapidAll')
    TST.testing = 'Yes';
    TST.testspeed = 'Rapid'; 
    TST.traj = 'All';
elseif strcmp(testing,'Standard')
    TST.testing = 'Yes';
    TST.testspeed = 'Standard';
    TST.traj = TstTrj;
elseif strcmp(testing,'No')
    TST.testing = 'No';
    TST.testspeed = '';
    TST.traj = 'All';
end
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';

%------------------------------------------
% Visualization 
%------------------------------------------
if strcmp(TST.testing,'Yes')
    SPIN.Vis = 'No';
    CACC.Vis = 'Yes';
    DESOL.Vis = 'No';
    KSMP.Vis = 'Yes';
    GVis = 'Yes';
    KVis = 'Yes';
    TVis = 'Yes';
else
    SPIN.Vis = 'No';
    CACC.Vis = 'No';
    DESOL.Vis = 'No';
    KSMP.Vis = 'Yes';
    GVis = 'Yes';
    KVis = 'Yes';
    TVis = 'Yes';
end

%==================================================================
% Test / Tweak
%==================================================================
if strcmp(mode,'TestTweak')

    %----------------------------------------------------
    % Test Slew-Rate - Step Responce 
    %----------------------------------------------------    
    % - run SysRel file and check below and good gslew etc...
    %if isfield(SYSREL,'gslew')
        %if (SYSREL.gslew ~= filenumber)
        % 
        %end
    %end
    
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
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
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
        
    if strcmp(TVis,'Yes')
        fh = figure(500); clf;
        fh.Name = 'Solution Fineness Testing for Waveform Generation';
        fh.NumberTitle = 'off';
        fh.Position = [400 150 1000 800];
        subplot(2,2,1); hold on; axis equal; grid on; box off;
        plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
        lim = PROJdgn.rad;
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Full Trajectory');
 
        subplot(2,2,2); hold on; axis equal; grid on; box off;
        ind = find(Rad >= 2*PROJdgn.p,1);    
        plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-');
        ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
        plot3(ploc(1),ploc(2),ploc(3),'rx');
        lim = ceil(PROJdgn.rad*2*PROJdgn.p);
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Initial Portion');
        set(gca,'cameraposition',[-31 -39 12.5]); 
        
        subplot(2,2,3); hold on;
        plot(Rad,PROJdgn.rad*MagkStep,'k');
        plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
        plot([0 1],[0.1 0.1],':');
        plot([0 1],[1 1],':');
        ylim([0 1.1]);
        xlabel('Relative Radius'); ylabel('kStep'); xlim([0 1]); title('Solution Sampling Fineness');

        subplot(2,2,4); hold on; axis equal; grid on; box off;
        plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
        lim = 0.5;
        xlim([-lim,lim]); ylim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[0 0 5000]);
        set(gca,'CameraTargetMode','manual');
        set(gca,'CameraTarget',[0 0 0]);
        set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5)); title('Solution Quantization Deflection @ Centre');

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
    GQNT.samparr = (0:SYS.GradSampBase/1000:PROJdgn.tro);
    GQNT.scnrarr = GQNT.samparr;
    GQNT.divno = 1;
    GQNT.mingseg = SYS.GradSampBase/1000;
    GQNT.gseg = SYS.GradSampBase/1000;
    
    %---------------------------------------------
    % Test Quantization
    %---------------------------------------------
    if GQNT.samparr(length(GQNT.samparr)) ~= PROJdgn.tro 
        err.flag = 1;
        err.msg = 'Tro not a multiple of System Gseg';
        return
    end

    %----------------------------------------------------
    % Quantize Trajectories
    %----------------------------------------------------
    Status2('busy','Quantize Trajectories',2);
    GQKSA = Quantize_Projections_v1c(IMETH.T,IMETH.KSA,GQNT.samparr);

    %---------------------------------------------
    % Test
    %---------------------------------------------
	m = 2:length(GQKSA(1,:,1));
    kStep = [GQKSA(:,1,:) GQKSA(:,m,:) - GQKSA(:,m-1,:)];
    MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
    MagkStep = mean(MagkStep,1);
    Rad = sqrt(GQKSA(:,:,1).^2 + GQKSA(:,:,2).^2 + GQKSA(:,:,3).^2);
    Rad = mean(Rad,1);
    
    if round(Rad(end)*1e4) ~= 1e4 && not(strcmp(TST.testspeed,'Rapid'))
        test = round(Rad(end)*1e4)
        error
    end
        
    if strcmp(GVis,'Yes')
        fhwfm = figure(1000); 
        fhwfm.Name = 'Gradient Waveforms';
        fhwfm.NumberTitle = 'off';
        fhwfm.Position = [200 150 1400 800];
        
        subplot(2,3,1); hold on;
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(1,:,1),'k'); plot(GQNT.samparr,PROJdgn.kmax*GQKSA(1,:,1),'b*');
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(1,:,2),'k'); plot(GQNT.samparr,PROJdgn.kmax*GQKSA(1,:,2),'g*');
        plot(IMETH.T,PROJdgn.kmax*IMETH.KSA(1,:,3),'k'); plot(GQNT.samparr,PROJdgn.kmax*GQKSA(1,:,3),'r*');
        plot(IMETH.T,zeros(size(IMETH.T)),'k:');
        xlabel('(ms)'); ylabel('kSpace (1/m)'); title('kSpace Quantization');
    end
    
    if strcmp(TVis,'Yes')
        figure(500); 
        subplot(2,2,1); hold on; axis equal; grid on; box off;
        plot3(PROJdgn.rad*GQKSA(1,:,1),PROJdgn.rad*GQKSA(1,:,2),PROJdgn.rad*GQKSA(1,:,3),'b-');
        subplot(2,2,2); hold on; axis equal; grid on; box off;
        ind = find(Rad >= 2*PROJdgn.p,1);
        plot3(PROJdgn.rad*GQKSA(1,1:ind,1),PROJdgn.rad*GQKSA(1,1:ind,2),PROJdgn.rad*GQKSA(1,1:ind,3),'b-');
        ploc = interp1(Rad,PROJdgn.rad*squeeze(GQKSA(1,:,:)),PROJdgn.p,'spline');
        plot3(ploc(1),ploc(2),ploc(3),'rx');
        subplot(2,2,3); hold on;
        plot(Rad,PROJdgn.rad*MagkStep,'b');
        subplot(2,2,4); hold on; axis equal; grid on; box off;
        plot3(PROJdgn.rad*GQKSA(1,:,1),PROJdgn.rad*GQKSA(1,:,2),PROJdgn.rad*GQKSA(1,:,3),'b-');              
    end    

    %----------------------------------------------------
    % Solve Gradient Quantization
    %----------------------------------------------------
    GQKSA = PROJdgn.kmax*GQKSA;
    IMETH.GQKSA = GQKSA;
    Status2('busy','Solve Gradient Quantization',2);
    G0 = SolveGradQuant_v1b(GQNT.scnrarr,GQKSA,PROJimp.gamma);
 
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
    [TEND,err] = func(TEND,INPUT);
    if err.flag
        return
    end    
    Gend = TEND.Gend;
    G0wend = cat(2,G0,Gend);
    qTend = PROJdgn.tro +(GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
    qTwend = [GQNT.scnrarr qTend];
    
    %----------------------------------------------------
    % Smooth
    %----------------------------------------------------
    % BAD - don't do this
    
    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(GVis,'Yes')
        [A,B,C] = size(G0wend);
        Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
        for n = 1:length(qTwend)-1
            L((n-1)*2+1) = qTwend(n);
            L(n*2) = qTwend(n+1);
            Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
            Gvis(:,n*2,:) = G0wend(:,n,:);
        end
        figure(1000); subplot(2,3,2); hold on; 
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
    cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
    IMETH.G0wendmax = max(G0wend(:));
    IMETH.G0wendmaxcartslew = max(abs(cartgsteps(:)))/GQNT.gseg; 
    IMETH.G0wendmaxcart2drv = (max(max(max(abs(cartg2drv(:,1:length(GQNT.scnrarr)-1,:))))))/GQNT.gseg^2;
    if strcmp(GVis,'Yes') 
        figure(1000); subplot(2,3,3); hold on; 
        for p = 1:length(cartgsteps(1,:,1));
            maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
        end
        title('Max Gradient Channel Speed');
        ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
        plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'y-');
        figure(1000); subplot(2,3,4); hold on; 
        for p = 1:length(cartg2drv(1,:,1));
            maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
        end
        plot(qTwend(2:length(GQNT.scnrarr)-1),maxcartg2drvT(2:length(GQNT.scnrarr)-1)/GQNT.gseg^2,'y-');
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
    INPUT.T = qTwend;
    INPUT.G0 = G0wend;
    INPUT.SYS = SYS;
    INPUT.mode = 'Compensate';
    [SYSRESP,err] = func(SYSRESP,INPUT);
    if err.flag
        return
    end
    Gcomp = SYSRESP.Gcomp;    
    qTcomp = SYSRESP.Tcomp;
    SYSRESP = rmfield(SYSRESP,{'Gcomp','Tcomp'});
    
    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(GVis,'Yes') 
        [A,B,C] = size(Gcomp);
        Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
        for n = 1:length(qTcomp)-1
            L((n-1)*2+1) = qTcomp(n);
            L(n*2) = qTcomp(n+1);
            Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
            Gvis(:,n*2,:) = Gcomp(:,n,:);
        end
        figure(1000); subplot(2,3,2); hold on; 
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
    figure(1000); subplot(2,3,5); hold on; 
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
    cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
    IMETH.Gcompmax = max(Gcomp(:));
    IMETH.Gcompmaxcartslew = max(abs(cartgsteps(:)))/GQNT.gseg; 
    IMETH.Gcompmaxcart2drv = (max(max(max(abs(cartg2drv(:,1:length(GQNT.scnrarr)-1,:))))))/GQNT.gseg^2;
    if strcmp(GVis,'Yes') 
        figure(1000); subplot(2,3,3); hold on; 
        for p = 1:length(cartgsteps(1,:,1));
            maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
        end
        title('Max Gradient Channel Speed');
        ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
        plot(qTcomp(2:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
        figure(1000); subplot(2,3,4); hold on; 
        for p = 1:length(cartg2drv(1,:,1));
            maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
        end
        plot(qTcomp(2:length(GQNT.scnrarr)-1),maxcartg2drvT(2:length(GQNT.scnrarr)-1)/GQNT.gseg^2,'k-');
        title('Max Gradient Channel Acceleration');
        ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
    end    
 
    %----------------------------------------------------
    % Gradient Abs Test
    %----------------------------------------------------    
    GabsComp = sqrt(Gcomp(:,:,1).^2 + Gcomp(:,:,2).^2 + Gcomp(:,:,3).^2);
    Gabs = sqrt(G0wend(:,:,1).^2 + G0wend(:,:,2).^2 + G0wend(:,:,3).^2);   
    GabsComp = mean(GabsComp,1);
    Gabs = mean(Gabs,1);
        
    %----------------------------------------------------
    % Gradient Return
    %----------------------------------------------------
    IMETH.Gscnr = Gcomp;
    IMETH.qTscnr = qTcomp;
    IMETH.tgwfm = qTcomp(length(qTcomp));
    IMETH.TstTrj = TstTrj;
    IMETH.GmaxEffMag = max(Gabs);
    IMETH.GmaxSncrChan = max(GabsComp);
    
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
    INPUT.T = IMETH.qTscnr;
    INPUT.G0 = IMETH.Gscnr;
    INPUT.SYS = SYS;
    INPUT.mode = 'Analyze';
    [SYSRESP,err] = func(SYSRESP,INPUT);
    if err.flag
        return
    end
    Grecon = SYSRESP.Grecon;  
    qTrecon = SYSRESP.Trecon;
    SYSRESP = rmfield(SYSRESP,{'Grecon','Trecon'});

    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(GVis,'Yes') 
        [A,B,C] = size(Grecon);
        Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
        for n = 1:length(qTrecon)-1
            L((n-1)*2+1) = qTrecon(n);
            L(n*2) = qTrecon(n+1);
            Gvis(:,(n-1)*2+1,:) = Grecon(:,n,:);
            Gvis(:,n*2,:) = Grecon(:,n,:);
        end
        figure(1000); subplot(2,3,2); hold on; 
        plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
        title(['Traj',num2str(1)]);
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end     
    
    %----------------------------------------------------
    % Resample k-Space
    %----------------------------------------------------
    Status2('busy','Calculate',2);
    if SYS.SampTransitTime == 0
        subsamp = PROJimp.dwell;
    else
        subsamp = 0.001;
    end
    Samp0 = (0:subsamp:IMETH.tgwfm+0.5);    
    [Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon,Samp0,PROJimp.gamma);
     
    TrajEndMag = TSMP.tro + SYSRESP.GradDelEff;
    SampTrajEndMagRealTime = TrajEndMag + SYS.SampTransitTime;                                  % real time when end of trajectory sampled
    EffWfmSampMag = (0:PROJimp.dwell:SampTrajEndMagRealTime+0.00001) - SYS.SampTransitTime;     % sampling timing on waveform   
    
    KSMP.DiscardStart = IMETH.InitSampDiscard;
    KSMP.DiscardEnd = TSMP.nproMag - length(EffWfmSampMag);
    
    SampRecon = EffWfmSampMag(KSMP.DiscardStart+1:end);
    if SampRecon(1) < 0 
        test0 = SampRecon(1)
        error
    end
    KSMP.StartTimeOnWfm = SampRecon(1);
    KSMP.EndTimeOnWfm = SampRecon(end);
    KSMP.nproRecon = length(SampRecon);
      
    if SYS.SampTransitTime == 0
        ind1 = find(round(Samp0*1e12) == round(SampRecon(1)*1e12));
        ind2 = find(round(Samp0*1e12) == round(SampRecon(end)*1e12));
        if (isempty(ind1) || isempty(ind2))
            error
        end
        KmatRecon = Kmat0(:,ind1:ind2,:);
    else
        [nproj,~,~] = size(Grecon);
        KmatRecon = zeros(nproj,KSMP.nproRecon,3);  
        for n = 1:nproj
            for d = 1:3
                %KmatRecon(n,:,d) = interp1(Samp0,Kmat0(n,:,d),SampRecon,'pchip');
                KmatRecon(n,:,d) = interp1(Samp0,Kmat0(n,:,d),SampRecon,'linear');
            end
        end
    end
       
    %---------------------------------------------
    % Visuals
    %---------------------------------------------
    if strcmp(KVis,'Yes') 
        figure(500);
        subplot(2,2,1);
        plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
        lim = PROJdgn.rad;
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[-31 -39 12.5]); 
        
        subplot(2,2,2); 
        Rad = sqrt(KmatRecon(:,:,1).^2 + KmatRecon(:,:,2).^2 + KmatRecon(:,:,3).^2);
        Rad = mean(Rad/PROJdgn.kmax,1);
        ind = find(Rad >= 2*PROJdgn.p,1);
        plot3(KmatRecon(1,1:ind,1)/PROJdgn.kstep,KmatRecon(1,1:ind,2)/PROJdgn.kstep,KmatRecon(1,1:ind,3)/PROJdgn.kstep,'r-');
        lim = ceil(PROJdgn.rad*2*PROJdgn.p);
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[-31 -39 12.5]); 
        
        subplot(2,2,4);
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
        fhk.Position = [400 150 1000 800];
        subplot(2,2,1); hold on; 
        plot(Samp0,Kmat0(1,:,1),'k-'); plot(Samp0,Kmat0(1,:,2),'k-'); plot(Samp0,Kmat0(1,:,3),'k-');
        plot(SampRecon,KmatRecon(1,:,1),'b*'); plot(SampRecon,KmatRecon(1,:,2),'g*'); plot(SampRecon,KmatRecon(1,:,3),'r*');
        xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('Sampling Along Readout');
        
        subplot(2,2,2); hold on;
        pts = 50;
        plot(KmatRecon(1,1:pts,1)/PROJdgn.kstep,'b*'); plot(KmatRecon(1,1:pts,2)/PROJdgn.kstep,'g*'); plot(KmatRecon(1,1:pts,3)/PROJdgn.kstep,'r*');    
        xlim([0 pts]);
        xlabel('Sampling Points'); ylabel('kSpace Steps'); title('Initial Sampled Points');
        
        subplot(2,2,3); hold on;
        if length(Kend(:,1,1)) == 1
            plot(Kend(:,1,1),'b*'); plot(Kend(:,1,2),'g*'); plot(Kend(:,1,3),'r*');
        else
            plot(Kend(:,1,1),'b'); plot(Kend(:,1,2),'g'); plot(Kend(:,1,3),'r');
        end
        xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Trajectory End');
        
        subplot(2,2,4); hold on;
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
    KSMP.maxfreq = IMETH.GmaxEffMag*PROJimp.gamma*PROJdgn.fov/2;
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
    IMETH.KSMP = KSMP;    
    
end

Status2('done','',2);
Status2('done','',3);
    
    
