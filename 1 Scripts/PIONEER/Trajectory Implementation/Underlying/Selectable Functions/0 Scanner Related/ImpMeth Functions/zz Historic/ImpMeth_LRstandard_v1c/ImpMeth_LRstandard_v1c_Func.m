%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_LRstandard_v1c_Func(IMETH,INPUT)

Status2('busy','Implement Standard 3D Looping Radial',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
PROJdgn = INPUT.DES.PROJdgn;
if not(strcmp(PROJdgn.TrajType,'LR3D'))
    err.flag = 1;
    err.msg = 'ImpMeth_LRstandard is not valid for the trajectory design';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
ORNT = IMETH.ORNT;
DESOL = IMETH.DESOL;
CACC = IMETH.CACC;
GCOMP = IMETH.GCOMP;
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
if not(exist(DES.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(DES.genprojfunc);

%------------------------------------------
% Visualization 
%------------------------------------------
if strcmp(testing,'Yes');
    SPIN.Vis = 'No';
    CACC.Vis = 'No';
    DESOL.Vis = 'Yes';
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
    TVis = 'No';
end

%------------------------------------------
% Testing Things
%------------------------------------------
TST.initstrght = 'No';
TST.relprojlenmeas = 'No';
TstTrj = 1;

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
    INPUT.PROJdgn = PROJdgn;
    INPUT.TST = TST;
    func = str2func([IMETH.desoltimfunc,'_Func']);           
    [DESOL,err] = func(DESOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;

    %---------------------------------------------
    % Generate Test Trajectories
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    INPUT.SPIN = SPIN;
    INPUT.DESOL = DESOL;
    INPUT.PSMP.phi = pi/2;
    INPUT.PSMP.theta = 0;
    INPUT.TST = TST;
    tic
    [OUTPUT,err] = genprojfunc(INPUT);
    toc
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
	Step = KSA(1,2:length(KSA),:) - KSA(1,1:length(KSA)-1,:);
    MagStep = PROJdgn.rad*sqrt(Step(1,:,1).^2 + Step(1,:,2).^2 + Step(1,:,3).^2);
    MaxStep = max(MagStep)
    ind = find(MagStep == MaxStep);
    Rad = sqrt(KSA(1,:,1).^2 + KSA(1,:,2).^2 + KSA(1,:,3).^2);
    relKatMaxStep = Rad(ind)
    ind2 = find(Rad >= PROJdgn.p,1);
    relKatStepAtP = MagStep(ind2)
    
    if strcmp(TVis,'Yes')
        ind = find(Rad >= 2*PROJdgn.p,1);
        ind2 = find(Rad >= PROJdgn.p,1);
        figure(500); hold on; axis equal; grid on; box off;
        plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-*','linewidth',1);
        plot3(PROJdgn.rad*KSA(1,ind2,1),PROJdgn.rad*KSA(1,ind2,2),PROJdgn.rad*KSA(1,ind2,3),'rx','linewidth',1);
        lim = ceil(PROJdgn.rad*2*PROJdgn.p);
        xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
        xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
        set(gca,'cameraposition',[-31 -39 12.5]); 
    end  
    button = questdlg('Continue?');
    if strcmp(button,'No')
        return
    end
    
    %------------------------------------------
    % Constrain Acceleration #1
    %------------------------------------------    
    INPUT.kArr = squeeze(KSA(1,:,:));
    INPUT.TArr = T;
    INPUT.PROJdgn = PROJdgn;
    INPUT.DESOL = DESOL;
    INPUT.TST = TST;
    INPUT.type = '3D';
    func = str2func([IMETH.accconstfunc,'_Func']);  
    [CACC,err] = func(CACC,INPUT);
    if err.flag == 1
        return
    end
    clear INPUT;   
    T = CACC.TArr;
    
    figure(10000); hold on;
    plot(T,Rad);
    error();
    
    %---------------------------------------------
    % Return
    %--------------------------------------------- 
    IMETH.impPROJdgn = PROJdgn;
    IMETH.PROJimp = PROJimp;
    IMETH.T = T;
    IMETH.SPIN = SPIN;
    IMETH.DESOL = DESOL;
end

%==================================================================
% Generate Design
%==================================================================
if strcmp(mode,'GenDes')

    %----------------------------------------------------
    % Generate
    %----------------------------------------------------    
    INPUT.PROJdgn = PROJdgn;
    INPUT.SPIN = IMETH.SPIN;
    INPUT.DESOL = IMETH.DESOL;
    INPUT.PSMP = PSMP;
    INPUT.TST = TST;
    [OUTPUT,err] = genprojfunc(INPUT);
    if err.flag
        return
    end
    KSA0 = OUTPUT.KSA;  
    
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
    GQKSA = Quantize_Projections_v1b(PROJdgn.tro,IMETH.T,GQNT.samparr,IMETH.KSA);
    GQKSA = PROJdgn.kmax*GQKSA;
    IMETH.GQKSA = GQKSA;

    %----------------------------------------------------
    % Solve Gradient Quantization
    %----------------------------------------------------
    Status2('busy','Solve Gradient Quantization',2);
    G0 = SolveGradQuant_v1b(GQNT.scnrarr,GQKSA,PROJimp.gamma);
     
    %----------------------------------------------------
    % End Trajectory
    %----------------------------------------------------
    Status2('busy','End Trajectory',2);
    func = str2func([IMETH.TENDfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.GQNT = GQNT;
    INPUT.GQKSA = GQKSA;
    INPUT.G0 = G0;
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
        figure(1000); hold on; plot(L,zeros(size(L)),'k:');
        plot(L,Gvis(TstTrj,:,1),'b:'); plot(L,Gvis(TstTrj,:,2),'g:'); plot(L,Gvis(TstTrj,:,3),'r:');
        title(['Traj ',num2str(TstTrj)]);
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end    

    %---------------------------------------------
    % Calculate Derivatives
    %---------------------------------------------
    Status2('busy','Calculate Gradient Derivatives',2);
    m = (2:length(G0wend(1,:,1))-2);
    cartgsteps = [G0wend(:,1,:) G0wend(:,m,:)-G0wend(:,m-1,:)];
    cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
    vecgsteps = sqrt(cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2);
    vecg2drv = sqrt(cartg2drv(:,:,1).^2 + cartg2drv(:,:,2).^2 + cartg2drv(:,:,3).^2);

    %---------------------------------------------
    % Plot Gradient Speed
    %---------------------------------------------
    t = qTwend(2:length(qTwend)-2);
    figure(2000); hold on; plot(t,zeros(size(t)),'k:');
    plot(t,vecgsteps(1,:)/GQNT.gseg,'b-');
    if length(vecgsteps(:,1)) > 1
        plot(t,vecgsteps(2,:)/GQNT.gseg,'b-');
    end
    %ylim([-200 200]);
    title('Gradient Speed Test');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');

    %----------------------------------------------------
    % Calculate Relevant Gradient Parameters in Magnet
    %----------------------------------------------------
    Status2('busy','Calculate Relevant Gradient Parameters in Magnet',3);
    IMETH.G0wendmax = max(G0wend(:));
    IMETH.G0wendmaxslew = max(vecgsteps(:))/GQNT.gseg; 
    figure(2000); hold on;
    for p = 1:length(vecgsteps(1,:));
        maxvecgsteps(p) = max(vecgsteps(:,p));
    end
    plot(qTwend(2:length(qTwend)-2),maxvecgsteps/GQNT.gseg,'k');
    title('Gradient Speed Test');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');  

    %---------------------------------------------
    % Plot Gradient Acceleration
    %---------------------------------------------
    t = qTwend(2:length(qTwend)-2);
    figure(2500); hold on; plot(t,zeros(size(t)),'k:');
    plot(t,vecg2drv(1,:)/GQNT.gseg^2,'b-');
    if length(vecg2drv(:,1)) > 1
        plot(t,vecg2drv(2,:)/GQNT.gseg^2,'b-');
    end
    ylim([-10000 10000]);
    title('Gradient Acceleration Test');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold'); 
    
    %----------------------------------------------------
    % Compensate for Transient Response
    %----------------------------------------------------
    Status2('busy','Compensate for Transient Response',2);
    func = str2func([IMETH.GCOMPfunc,'_Func']);
    INPUT.PROJimp = PROJimp;
    INPUT.T = qTwend;
    INPUT.G0 = G0wend;
    [GCOMP,err] = func(GCOMP,INPUT);
    if err.flag
        return
    end
    Gcomp = GCOMP.G;    
      
    %----------------------------------------------------
    % Visuals
    %----------------------------------------------------
    if strcmp(GVis,'Yes') 
        [A,B,C] = size(Gcomp);
        Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
        for n = 1:length(qTwend)-1
            L((n-1)*2+1) = qTwend(n);
            L(n*2) = qTwend(n+1);
            Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
            Gvis(:,n*2,:) = Gcomp(:,n,:);
        end
        figure(1000); hold on; 
        plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-'); plot(L,Gvis(TstTrj,:,3),'r-');
        title(['Traj',num2str(TstTrj)]);
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end    

    %----------------------------------------------------
    % Calculate Acoustic Frequency Response
    %----------------------------------------------------    
    Glen = length(Gcomp(TstTrj,:,1));
    zfGcompX = zeros(1,10000);
    zfGcompY = zeros(1,10000);
    zfGcompZ = zeros(1,10000);    
    zfGcompX(1:Glen) = squeeze(Gcomp(TstTrj,:,1)); 
    zfGcompY(1:Glen) = squeeze(Gcomp(TstTrj,:,2)); 
    zfGcompZ(1:Glen) = squeeze(Gcomp(TstTrj,:,3));     
    ftGcompX = abs(fftshift(fft(zfGcompX)));
    ftGcompY = abs(fftshift(fft(zfGcompY)));
    ftGcompZ = abs(fftshift(fft(zfGcompZ)));    
    figure(10000); hold on;
    fstep = 1/(10000*GQNT.gseg);
    freq = (-1/(2*GQNT.gseg):fstep:(1/(2*GQNT.gseg))-fstep);
    freq = freq*1000;
    RefSin = 30*sin(1000*2*pi*qTwend(1:end-1)/1000);
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
    IMETH.Gcompmaxcart2drv = (max(max(max(abs(cartg2drv(:,1:length(qTwend)-10,:))))))/GQNT.gseg^2;
    if strcmp(GVis,'Yes') 
        figure(2000); hold on;
        for p = 1:length(cartgsteps(1,:,1));
            maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
        end
        title('Gradient Speed Test');
        ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
        plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'m-');
        figure(2500); hold on;
        for p = 1:length(cartg2drv(1,:,1));
            maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
        end
        plot(qTwend(2:length(qTwend)-10),maxcartg2drvT(2:length(qTwend)-10)/GQNT.gseg^2,'m-');
        title('Gradient Acceleration Test');
        ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold');    
    end    
 
    %----------------------------------------------------
    % Gradient Abs Test
    %----------------------------------------------------    
    Gabs = sqrt(Gcomp(1,:,1).^2 + Gcomp(1,:,2).^2 + Gcomp(1,:,3).^2);
    if strcmp(GVis,'Yes') 
        figure(2600); hold on;
        plot(qTwend(1:end-1),Gabs,'k');
        title('Gradient Amplitude Test');
        ylabel('Gradient Amplitude (mT/m)','fontsize',10,'fontweight','bold');
        xlabel('(ms)','fontsize',10,'fontweight','bold'); 
    end
        
    %----------------------------------------------------
    % Gradient Return
    %----------------------------------------------------
    IMETH.Gscnr = Gcomp;
    IMETH.qTscnr = qTwend;
    IMETH.tgwfm = qTwend(length(qTwend));
    IMETH.TstTrj = TstTrj;
    IMETH.Gmax = IMETH.Gcompmax;
    
    %----------------------------------------------------
    % Panel Output
    %----------------------------------------------------
    Panel(1,:) = {'Gmax (amp)',IMETH.Gcompmax,'Output'};
    Panel(2,:) = {'GmaxChanSlew (amp)',IMETH.Gcompmaxcartslew,'Output'};
    Panel(3,:) = {'GmaxChan2drv (amp)',IMETH.Gcompmaxcart2drv,'Output'};
    Panel(4,:) = {'Gmax (mag)',IMETH.G0wendmax,'Output'};
    Panel(5,:) = {'GmaxVecSlew (mag)',IMETH.G0wendmaxslew,'Output'};
    Panel(6,:) = {'tgwfm',IMETH.tgwfm,'Output'};
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
    [SYSRESP,err] = func(SYSRESP,INPUT);
    if err.flag
        return
    end
    Grecon = SYSRESP.G;  
    qTrecon = SYSRESP.T;

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
        figure(1000); hold on; 
        plot(L,Gvis(TstTrj,:,1),'b-'); plot(L,Gvis(TstTrj,:,2),'g-'); plot(L,Gvis(TstTrj,:,3),'r-');
        title(['Traj',num2str(TstTrj)]);
        xlabel('(ms)','fontsize',10,'fontweight','bold');
        ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
    end     
    
    %----------------------------------------------------
    % Resample k-Space
    %----------------------------------------------------
    Status2('busy','Calculate',2);
    subsamp = 0.002;
    Samp0 = (0:subsamp:IMETH.tgwfm);    
    [Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon,Samp0,PROJimp.gamma);
    
    SampMag = SYS.SampDel+(0:PROJimp.dwell:TSMP.troMag-PROJimp.dwell+0.00001);    
    DiscardStart = ceil((SYS.GradDel-SYS.SampDel)/PROJimp.dwell)+TSMP.discard;
    DiscardEnd = TSMP.nproMag - TSMP.nproRecon - DiscardStart;
    KSMP.DiscardStart = DiscardStart;
    KSMP.DiscardEnd = DiscardEnd;
    SampRecon = SampMag(DiscardStart+1:end-DiscardEnd)-SYS.GradDel;
    if SampRecon(1) < 0 || SampRecon(end) > TSMP.tro
        test0 = SampRecon(1)
        test1 = SampRecon(end)
        error
    end
    if SampRecon == 0
        err.flag = 1;
        err.msg = 'Discard a Sampling Point';
        return
    end
    KSMP.StartTimeOnWfm = SampRecon(1);
    KSMP.EndTimeOnWfm = SampRecon(end);
    
    [nproj,~,~] = size(Grecon);
    KmatRecon = zeros(nproj,TSMP.nproRecon,3);    
    for n = 1:nproj
        for d = 1:3
            KmatRecon(n,:,d) = interp1(Samp0,Kmat0(n,:,d),SampRecon);
        end
    end
 
    %---------------------------------------------
    % Visuals
    %---------------------------------------------
    if strcmp(KVis,'Yes') 
        figure(3000); hold on; 
        plot(Samp0,Kmat0(TstTrj,:,1),'k-'); plot(Samp0,Kmat0(TstTrj,:,2),'k-'); plot(Samp0,Kmat0(TstTrj,:,3),'k-');
        plot(SampRecon,KmatRecon(TstTrj,:,1),'b*'); plot(SampRecon,KmatRecon(TstTrj,:,2),'g*'); plot(SampRecon,KmatRecon(TstTrj,:,3),'r*');
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
    for n = 2:TSMP.nproRecon
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
    KSMP.tatr = (TSMP.discard*PROJimp.dwell:PROJimp.dwell:PROJimp.tro-PROJimp.dwell);    

    %----------------------------------------------------
    % Other
    %----------------------------------------------------
    KSMP.maxfreq = IMETH.Gmax*PROJimp.gamma*PROJdgn.fov/2;
    KSMP.samp = samp;
    KSMP.Kmat = Kmat;
    KSMP.Kend = Kend;
    KSMP.maxKend = maxKend;   
    
    %----------------------------------------------------
    % Panel
    %----------------------------------------------------
    Panel(1,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
    Panel(2,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
    Panel(3,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
    Panel(4,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
    Panel(5,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
    Panel(6,:) = {'rSNR',KSMP.rSNR,'Output'};
    Panel(7,:) = {'maxkend',KSMP.maxKend,'Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
    KSMP.PanelOutput = PanelOutput;     
 
    %----------------------------------------------------
    % Return
    %----------------------------------------------------
    IMETH.KSMP = KSMP;    
    
    Status2('done','',2);
    Status2('done','',3);

end
     
    
    
