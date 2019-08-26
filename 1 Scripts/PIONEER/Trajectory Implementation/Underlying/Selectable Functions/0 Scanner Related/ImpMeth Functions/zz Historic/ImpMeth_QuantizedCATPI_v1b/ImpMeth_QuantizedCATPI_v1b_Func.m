%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_QuantizedCATPI_v1b_Func(IMETH,INPUT)

Status2('busy','Implement Quantized CATPI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
PROJdgn = INPUT.DES.PROJdgn;
if not(isfield(PROJdgn,'TrajType'))
    err.flag = 1;
    err.msg = 'Either update design of use older implementation';
    return
end
if not(strcmp(PROJdgn.TrajType,'TPI'))
    err.flag = 1;
    err.msg = 'ImpMeth_QuantizedCATPI is not valid for the trajectory design';
    return
end
if not(isfield(PROJdgn,'iseg'))
    err.flag = 1;
    err.msg = 'Design / Implementation Not Compatible';
    return
end 

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp = INPUT.PROJimp;
PROJimp.genfunc = 'TPI_GenProj_v3d';
if not(exist(PROJimp.genfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
TST = INPUT.TST;
ORNT = IMETH.ORNT;
TCPLT = IMETH.TCPLT;
GQNT = IMETH.GQNT;
KSMP = IMETH.KSMP;
STEPRESP = IMETH.STEPRESP;
SYS = INPUT.SYS;
mode = INPUT.mode;
if isfield(INPUT,'PSMP')
    PSMP = INPUT.PSMP;
end
if isfield(INPUT,'TSMP')
    TSMP = INPUT.TSMP;
end
clear INPUT

%==================================================================
% Test / Tweak
%==================================================================
if strcmp(mode,'TestTweak')
    
    %----------------------------------------------------
    % CATPI
    %----------------------------------------------------
    PROJdgn0 = PROJdgn;
    PROJdgn0.iseg = IMETH.iseg;
    
    %----------------------------------------------------
    % Solve Gradient Quantization Vector
    %----------------------------------------------------
    Status2('busy','Solve Quantization',2);
    func = str2func([IMETH.qvecslvfunc,'_Func']);
    INPUT.PROJdgn = PROJdgn0;
    INPUT.PROJimp = PROJimp;
    INPUT.SYS = SYS;
    INPUT.mode = 'FindBest';
    [GQNT0,err] = func(GQNT,INPUT);
    if err.flag
        return
    end
    clear INPUT
    PROJimp.tro = GQNT0.besttro;
    PROJimp.iseg = GQNT0.bestiseg;
    PROJimp.twseg = GQNT0.besttwseg;

    %----------------------------------------------------
    % CATPI Related - Recalculate 'projlen' for new 'tro'
    %----------------------------------------------------
    Status2('busy','Determine Effect of Design Tweak',2);   
    func = str2func([PROJdgn.method,'_Func']);  
    tro = PROJimp.tro;
    tro0 = 0;
    while ceil(tro*1000) ~= ceil(tro0*1000);
        DES.tro = PROJimp.tro + DES.iseg - PROJimp.iseg; 
        INPUT = struct();
        [DES,err] = func(INPUT,DES);
        if err.flag ~= 0
            return
        end
        tro0 = tro;
        tro = DES.tro;
    end
    impPROJdgn = DES.PROJdgn;
    clear INPUT
    clear DES

    %---------------------------------------------
    % Return
    %--------------------------------------------- 
    IMETH.impPROJdgn = impPROJdgn;
    IMETH.PROJimp = PROJimp;     
end

%==================================================================
% Generate Design
%==================================================================
if strcmp(mode,'GenDes')

    %----------------------------------------------------
    % Generate
    %----------------------------------------------------    
    func = str2func(PROJimp.genfunc);  
    INPUT.PSMP = PSMP;
    INPUT.slvno = 1000;
    [DES,err] = func(DES,INPUT);
    if err.flag
        return
    end
    IMETH.T = DES.T;
    KSA0 = DES.KSA;
    
    %------------------------------------------
    % Orient
    %------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.KSA = KSA0;
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

    %----------------------------------------------------
    % Solve Gradient Quantization Vector
    %----------------------------------------------------
    Status2('busy','Solve Quantization',2);
    func = str2func([IMETH.qvecslvfunc,'_Func']);
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.SYS = SYS;
    INPUT.mode = 'Output';
    [GQNT,err] = func(GQNT,INPUT);
    if err.flag
        return
    end
    clear INPUT
    IMETH.GQNT = GQNT;
    
    %----------------------------------------------------
    % Test
    %----------------------------------------------------    
    if GQNT.tro ~= PROJimp.tro || GQNT.iseg ~= PROJimp.iseg || GQNT.twseg ~= PROJimp.twseg
        error();
    end
    testtro = GQNT.samparr(length(GQNT.samparr));
    if round(testtro*10000) ~= round(PROJdgn.tro*10000)  
        round(testtro*10000)
        round(PROJdgn.tro*10000)
        error();
    end

    %----------------------------------------------------
    % Quantize Trajectories
    %----------------------------------------------------
    Status2('busy','Quantize Trajectories',2);
    [GQKSA] = Quantize_Projections_v1b(PROJdgn.tro,IMETH.T,GQNT.samparr,IMETH.KSA);
    GQKSA = PROJdgn.kmax*GQKSA;
    IMETH.GQKSA = GQKSA;

    %----------------------------------------------------
    % Solve Gradient Quantization
    %----------------------------------------------------
    Status2('busy','Solve Gradient Quantization',2);
    qTtraj = GQNT.scnrarr;
    [G0] = SolveGradQuant_v1b(qTtraj,GQKSA,PROJimp.gamma);

    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(TST.GVis,'Yes') 
        nproj = length(G0(:,1,1));
        Gvis = []; L = [];
        for n = 1:length(qTtraj)-1
            L = [L [qTtraj(n) qTtraj(n+1)]];
            Gvis = [Gvis [G0(:,n,:) G0(:,n,:)]];
        end
        fh1 = figure(500); clf;
        fh1.Name = 'Gradient Waveform Test';
        fh1.NumberTitle = 'off';
        fh1.Position = [300 100 1200 800];
        subplot(2,2,1); hold on; plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:'); xlim([0 max(L)]);
        title('Traj1'); 
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
        subplot(2,2,2); hold on; plot(L,Gvis(nproj-1,:,1),'b:'); plot(L,Gvis(nproj-1,:,2),'g:'); plot(L,Gvis(nproj-1,:,3),'r:'); xlim([0 max(L)]); 
        title(['Traj',num2str(nproj-1)]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end
   
    %----------------------------------------------------
    % Compensate for Step Response
    %----------------------------------------------------
    Status2('busy','Compensate for Step Response',2);
    func = str2func([IMETH.steprespfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.GQNT = GQNT;
    INPUT.G0 = G0;
    INPUT.qT = qTtraj;      
    INPUT.GWFM = IMETH;
    INPUT.mode = 'Compensate';
    [STEPRESP,err] = func(STEPRESP,INPUT);
    if err.flag
        return
    end
    Gaccom = STEPRESP.Gaccom;
    IMETH.STEPRESP = STEPRESP;
    IMETH.sampend = PROJdgn.tro + STEPRESP.efftrajdel;
    IMETH.qTtraj = qTtraj;
    IMETH.Gaccom = Gaccom;
    
    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(TST.GVis,'Yes') 
        GvisA1 = []; GvisA1N = []; LA = [];
        for n = 1:length(qTtraj)-1
            LA = [LA [qTtraj(n) qTtraj(n+1)]];
            GvisA1 = [GvisA1 [squeeze(Gaccom(1,n,:)) squeeze(Gaccom(1,n,:))]];
            GvisA1N = [GvisA1N [squeeze(Gaccom(nproj-1,n,:)) squeeze(Gaccom(nproj-1,n,:))]];
        end
        GvisA1 = GvisA1.';
        GvisA1N = GvisA1N.';        
        figure(fh1); 
        subplot(2,2,1); hold on; 
        plot(LA,GvisA1(:,1),'b:','linewidth',1); plot(LA,GvisA1(:,2),'g:','linewidth',1); plot(LA,GvisA1(:,3),'r:','linewidth',1);
        subplot(2,2,2); hold on;  
        plot(LA,GvisA1N(:,1),'b:','linewidth',1); plot(LA,GvisA1N(:,2),'g:','linewidth',1); plot(LA,GvisA1N(:,3),'r:','linewidth',1);
    end    
    
    %---------------------------------------
    % Relative SRA
    %---------------------------------------
    magG0 = (G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2).^(0.5);
    magG = (Gaccom(:,:,1).^2 + Gaccom(:,:,2).^2 + Gaccom(:,:,3).^2).^(0.5);
    IMETH.absGSRA_maxI = max(magG(:,1) - magG0(:,1));
    IMETH.rGSRA_maxI = max(magG(:,1)./magG0(:,1));
    IMETH.rGSRA_maxTot = max(magG(:)./magG0(:));

    %---------------------------------------
    % Test Overshoot of Initial Segment
    %---------------------------------------
    kiseg = (GQKSA(1,2,1).^2 + GQKSA(1,2,2).^2 + GQKSA(1,2,3).^2).^(0.5);
    kovrshoot = PROJimp.gamma*(GQNT.twseg*IMETH.absGSRA_maxI)/4;
    IMETH.rIovershoot = (kiseg + kovrshoot)/kiseg;

    %---------------------------------------
    % Max Gradient Steps
    %---------------------------------------
    IMETH.Gmax = max(Gaccom(:));
    initsteps = Gaccom(:,1,:);
    IMETH.Gmaxinit = max(initsteps(:));
    m = (2:length(qTtraj)-2);
    twsteps = Gaccom(:,m,:)-Gaccom(:,m-1,:);
    IMETH.Gmaxtwstep = max(twsteps(:)); 
    for n = 1:nproj
        MaxN(n) = max(max(twsteps(n,:,:)));
    end
    bigstepcone = find(MaxN == max(MaxN));
    if strcmp(TST.GVis,'Yes') 
        figure(fh1); 
        subplot(2,2,3); hold on; 
        plot(L,Gvis(bigstepcone,:,1),'b:'); plot(L,Gvis(bigstepcone,:,2),'g:'); plot(L,Gvis(bigstepcone,:,3),'r:'); xlim([0 max(L)]);
        title(['Traj',num2str(bigstepcone),' (bigstepcone)']); 
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
        GvisAB = []; LA = [];
        for n = 1:length(qTtraj)-1
            LA = [LA [qTtraj(n) qTtraj(n+1)]];
            GvisAB = [GvisAB [squeeze(Gaccom(bigstepcone,n,:)) squeeze(Gaccom(bigstepcone,n,:))]];
        end
        GvisAB = GvisAB.'; 
        plot(LA,GvisAB(:,1),'b:','linewidth',1); plot(LA,GvisAB(:,2),'g:','linewidth',1); plot(LA,GvisAB(:,3),'r:','linewidth',1);
    end
    IMETH.bigstepcone = bigstepcone;

    %----------------------------------------------------
    % Complete Trajectory
    %---------------------------------------------------- 
    Status2('busy','Complete Trajectory',2);
    func = str2func([IMETH.trajcompletefunc,'_Func']);
    INPUT.PROJdgn = PROJdgn;
    INPUT.PROJimp = PROJimp;
    INPUT.GQNT = GQNT;
    INPUT.G = Gaccom;
    INPUT.SYS = SYS;
    INPUT.SR = STEPRESP.SR;
    [TCPLT,err] = func(TCPLT,INPUT);
    if err.flag
        return
    end
    IMETH.tgwfm = TCPLT.tgwfm;
    IMETH.Gscnr = TCPLT.G;
    IMETH.qTscnr = TCPLT.qTscnr;             

    %----------------------------------------------------
    % Final Plot
    %----------------------------------------------------    
    if strcmp(TST.GVis,'Yes') 
        GvisA1 = []; GvisA1N = []; GvisAB = []; LA = [];
        for n = 1:length(IMETH.qTscnr)-1
            LA = [LA [IMETH.qTscnr(n) IMETH.qTscnr(n+1)]];
            GvisA1 = [GvisA1 [squeeze(IMETH.Gscnr(1,n,:)) squeeze(IMETH.Gscnr(1,n,:))]];
            GvisAB = [GvisAB [squeeze(IMETH.Gscnr(bigstepcone,n,:)) squeeze(IMETH.Gscnr(bigstepcone,n,:))]];
            GvisA1N = [GvisA1N [squeeze(IMETH.Gscnr(nproj-1,n,:)) squeeze(IMETH.Gscnr(nproj-1,n,:))]];
        end
        GvisA1 = GvisA1.'; 
        GvisAB = GvisAB.'; 
        GvisA1N = GvisA1N.'; 
        figure(fh1); 
        subplot(2,2,1); plot(LA,GvisA1(:,1),'b-','linewidth',0.5); plot(LA,GvisA1(:,2),'g-','linewidth',0.5); plot(LA,GvisA1(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
        subplot(2,2,2); hold on; plot(LA,GvisA1N(:,1),'b-','linewidth',0.5); plot(LA,GvisA1N(:,2),'g-','linewidth',0.5); plot(LA,GvisA1N(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
        subplot(2,2,3); hold on; plot(LA,GvisAB(:,1),'b-','linewidth',0.5); plot(LA,GvisAB(:,2),'g-','linewidth',0.5); plot(LA,GvisAB(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
    end
    
    %----------------------------------------------------
    % Max Sampled Gradient
    %----------------------------------------------------            
    GabsTraj = sqrt(Gaccom(:,:,1).^2 + Gaccom(:,:,2).^2 + Gaccom(:,:,3).^2);   
    IMETH.GmaxTraj = max(GabsTraj(:));    
    
    %----------------------------------------------------
    % Panel Output
    %----------------------------------------------------
    Panel(1,:) = {'Gmax',IMETH.Gmax,'Output'};
    Panel(2,:) = {'Gmaxinit',IMETH.Gmaxinit,'Output'};
    Panel(3,:) = {'Gmaxtwstep',IMETH.Gmaxtwstep,'Output'};
    Panel(4,:) = {'tgwfm',IMETH.tgwfm,'Output'};
    %Panel = cat(1,Panel,TCPLT.Panel);
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    IMETH.PanelOutput = PanelOutput;    
end

%==================================================================
% Recon
%==================================================================
if strcmp(mode,'Recon')

    %---------------------------------------------
    % Testing
    %---------------------------------------------
    IMETH.maxfreq = IMETH.Gmax*PROJimp.gamma*PROJdgn.fov/2;

    %---------------------------------------------
    % Common
    %---------------------------------------------
    nproj = length(IMETH.Gscnr(:,1,1));

    %----------------------------------------------------
    % Include Step Response Effect
    %----------------------------------------------------
    Status2('busy','Include Step Response Effect',2);
    func = str2func([IMETH.steprespfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.GQNT = GQNT;
    INPUT.G0 = IMETH.Gaccom;
    INPUT.qT = IMETH.qTtraj;    
    INPUT.GWFM = IMETH;
    INPUT.mode = 'Analyze';
    [STEPRESP,err] = func(STEPRESP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    TGSR = STEPRESP.TGSR;
    mGSR = STEPRESP.mGSR;
    STEPRESP = rmfield(STEPRESP,{'Gaccom','SR','TGSR','segTGSR','GSR'});
    IMETH.STEPRESP = STEPRESP;

    %----------------------------------------------------
    % Visualize Step Response
    %----------------------------------------------------
    if strcmp(TST.GVis,'Yes')    
        Status('busy','Plot Gradient Step Response');
        GvisA1 = []; GvisA1N = []; GvisAB = []; LA = [];
        for n = 1:length(TGSR)-1
            LA = [LA [TGSR(n) TGSR(n+1)]];
            GvisA1 = [GvisA1 [squeeze(mGSR(1,n,:)) squeeze(mGSR(1,n,:))]];
            GvisAB = [GvisAB [squeeze(mGSR(IMETH.bigstepcone,n,:)) squeeze(mGSR(IMETH.bigstepcone,n,:))]];
            GvisA1N = [GvisA1N [squeeze(mGSR(nproj-1,n,:)) squeeze(mGSR(nproj-1,n,:))]];
        end
        GvisA1 = GvisA1.'; 
        GvisAB = GvisAB.'; 
        GvisA1N = GvisA1N.';  
        subplot(2,2,1); plot(LA,GvisA1(:,1),'b-','linewidth',0.5); plot(LA,GvisA1(:,2),'g-','linewidth',0.5); plot(LA,GvisA1(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
        subplot(2,2,2); hold on; plot(LA,GvisA1N(:,1),'b-','linewidth',0.5); plot(LA,GvisA1N(:,2),'g-','linewidth',0.5); plot(LA,GvisA1N(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
        subplot(2,2,3); hold on; plot(LA,GvisAB(:,1),'b-','linewidth',0.5); plot(LA,GvisAB(:,2),'g-','linewidth',0.5); plot(LA,GvisAB(:,3),'r-','linewidth',0.5); xlim([0 max(LA)]);
    end
        
    %----------------------------------------------------
    % Resample k-Space
    %---------------------------------------------------- 
    Status('busy','Resample k-Space');
    func = str2func([IMETH.ksampfunc,'_Func']);
    INPUT.IMETH = IMETH;
    INPUT.PROJimp = PROJimp;
    INPUT.TSMP = TSMP;
    INPUT.qTrecon = TGSR;
    INPUT.Grecon = mGSR;
    INPUT.SYSRESP = STEPRESP;
    INPUT.SYS = SYS;
    [KSMP,err] = func(KSMP,INPUT);
    if err.flag
        return
    end
    samp = KSMP.SampRecon;  
    Kmat = KSMP.KmatRecon;   
    
    %---------------------------------------
    % Visuals
    %---------------------------------------   
    if strcmp(TST.KVis,'Yes') 
        fh2 = figure(600); clf;
        fh2.Name = 'Sampling Test';
        fh2.NumberTitle = 'off';
        fh2.Position = [300 100 1200 800];   
        
        [L,~,~] = size(Kmat);
        subplot(2,2,1); hold on; 
        plot(samp,Kmat(1,:,1),'b*'); plot(samp,Kmat(1,:,2),'g*'); plot(samp,Kmat(1,:,3),'r*');
        subplot(2,2,2); hold on; 
        plot(samp,Kmat(L-1,:,1),'b*'); plot(samp,Kmat(L-1,:,2),'g*'); plot(samp,Kmat(L-1,:,3),'r*');
        subplot(2,2,3); hold on; 
        plot(samp,Kmat(IMETH.bigstepcone,:,1),'b*'); plot(samp,Kmat(IMETH.bigstepcone,:,2),'g*'); plot(samp,Kmat(IMETH.bigstepcone,:,3),'r*'); 

        [L,~,~] = size(IMETH.GQKSA);
        subplot(2,2,1); hold on; 
        plot(GQNT.scnrarr,IMETH.GQKSA(1,:,1),'b-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(1,:,1),'k-');     
        plot(GQNT.scnrarr,IMETH.GQKSA(1,:,2),'g-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(1,:,2),'k-');  
        plot(GQNT.scnrarr,IMETH.GQKSA(1,:,3),'r-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(1,:,3),'k-');
        title('Ksamp Traj1'); 
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
        subplot(2,2,2); hold on; 
        plot(GQNT.scnrarr,IMETH.GQKSA(L-1,:,1),'b-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(L-1,:,1),'k-');      
        plot(GQNT.scnrarr,IMETH.GQKSA(L-1,:,2),'g-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(L-1,:,2),'k-');  
        plot(GQNT.scnrarr,IMETH.GQKSA(L-1,:,3),'r-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(L-1,:,3),'k-');
        title(['Ksamp Traj',num2str(L-1)]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
        subplot(2,2,3); hold on; 
        plot(GQNT.scnrarr,IMETH.GQKSA(IMETH.bigstepcone,:,1),'b-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(IMETH.bigstepcone,:,1),'k-');      
        plot(GQNT.scnrarr,IMETH.GQKSA(IMETH.bigstepcone,:,2),'g-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(IMETH.bigstepcone,:,2),'k-');  
        plot(GQNT.scnrarr,IMETH.GQKSA(IMETH.bigstepcone,:,3),'r-'); plot(PROJdgn.tro*IMETH.T(1,:)/PROJdgn.projlen,PROJdgn.kmax*IMETH.KSA(IMETH.bigstepcone,:,3),'k-');
        title(['Ksamp Traj',num2str(IMETH.bigstepcone)]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
    end    
    
    %---------------------------------------
    % Test Max Relative Radial Sampling Step
    %---------------------------------------
    Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
    rRad = Rad/PROJdgn.kstep;
    KSMP.rRadFirstStepMean = mean(rRad(:,1));
    KSMP.rRadSecondStepMean = mean(rRad(:,2)-rRad(:,1));
    KSMP.rRadFirstStepMax = max(rRad(:,1));
    for n = 2:KSMP.nproRecon
        rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
    end
    KSMP.rRadStepMax = max(rRadStep(:));

    %----------------------------------------------------
    % Test Relative Sampling Maximums and Elip
    %----------------------------------------------------
    if strcmp(TST.testing,'Yes')
        phi = PSMP.PCD.testconephi;
        deslen = length(IMETH.KSA(1,:,1));
        for n = 1:nproj/2
            dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax*cos(phi(n)))^2) + (PROJdgn.kmax*sin(phi(n)))^2);
            dKmax2(n) = PROJdgn.kmax*(IMETH.KSA(n,deslen,1).^2 + IMETH.KSA(n,deslen,2).^2 + IMETH.KSA(n,deslen,3).^2).^(1/2);
            Kmax(n) = (Kmat(n,KSMP.nproRecon,1).^2 + Kmat(n,KSMP.nproRecon,2).^2 + Kmat(n,KSMP.nproRecon,3).^2).^(1/2);
            if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
                error();
            end
        end
    else
        phi = PSMP.PCD.conephi;
        projindx = PSMP.PCD.projindx;
        deslen = length(IMETH.KSA(1,:,1));
        for n = 1:length(phi)/2
            dKmax(n) = sqrt(((PROJdgn.elip*PROJdgn.kmax*cos(phi(n)))^2) + (PROJdgn.kmax*sin(phi(n)))^2);
            dKmax2(n) = PROJdgn.kmax*(IMETH.KSA(projindx{n}(1),deslen,1).^2 + IMETH.KSA(projindx{n}(1),deslen,2).^2 + IMETH.KSA(projindx{n}(1),deslen,3).^2).^(1/2);
            Kmax(n) = (Kmat(projindx{n}(1),KSMP.nproRecon,1).^2 + Kmat(projindx{n}(1),KSMP.nproRecon,2).^2 + Kmat(projindx{n}(1),KSMP.nproRecon,3).^2).^(1/2);
        end
        if abs((1 - dKmax(n)/dKmax2(n))) > 0.001 
            error();
        end
    end   
    rKmax = Kmax./dKmax;
    KSMP.meanrelkmax = mean(rKmax);
    KSMP.maxrelkmax = max(rKmax);
    KSMP.rSNR = PROJdgn.rSNR/(KSMP.meanrelkmax^3);

    %---------------------------------------
    % Return Sampling Timing for Testing
    %---------------------------------------
    if strcmp(TST.testing,'Yes')
        for n = 1:nproj/2   
            rKmag(n,:) = ((Kmat(n,:,1).^2 + Kmat(n,:,2).^2 + Kmat(n,:,3).^2).^(1/2))/Kmax(n);
        end
    else
        for n = 1:length(phi)/2
            rKmag(n,:) = ((Kmat(projindx{n}(1),:,1).^2 + Kmat(projindx{n}(1),:,2).^2 + Kmat(projindx{n}(1),:,3).^2).^(1/2))/Kmax(n);
        end
    end
    KSMP.rKmag = mean(rKmag,1);  
    KSMP.samp = samp;
    KSMP.Kmat = Kmat;
    
    %----------------------------------------------------
    % Panel
    %----------------------------------------------------
    if KSMP.rRadFirstStepMean > 0.35 || KSMP.rRadFirstStepMean < 0.15
        Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'OutputWarn'};
    else
        Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
    end
    if KSMP.rRadFirstStepMax > 0.4
        Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'OutputWarn'};
    else
        Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
    end
    Panel(3,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
    if KSMP.rRadStepMax > 0.8
        Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'OutputWarn'};
    else
        Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
    end
    Panel(5,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
    Panel(6,:) = {'rSNR',KSMP.rSNR,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    KSMP.PanelOutput = PanelOutput;

    %----------------------------------------------------
    % Return
    %----------------------------------------------------
    KSMP = rmfield(KSMP,{'Samp0','Kmat0','SampRecon','KmatRecon'});
    IMETH.KSMP = KSMP;    

end
    
    
    
    
    