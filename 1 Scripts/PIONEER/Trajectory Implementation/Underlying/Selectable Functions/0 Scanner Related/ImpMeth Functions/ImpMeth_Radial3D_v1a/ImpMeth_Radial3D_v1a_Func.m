%=====================================================
%  
%
%=====================================================

function [IMETH,err] = ImpMeth_Radial3D_v1a_Func(IMETH,INPUT)

Status('busy','Implement Radial 3D');

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
if not(strcmp(INPUT.DES.type,'Rad3D'))
    err.flag = 1;
    err.msg = '''ImpMeth_Radial3D'' is not valid for the trajectory design';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
clear INPUT

IMPTYPE = IMETH.IMPTYPE;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
TEND = IMETH.TEND;
SYSRESP = IMETH.IMPTYPE.SYSRESP;
KSMP = IMETH.KSMP;

%===============================================================================
% Define Projection Sampling
%===============================================================================
func = str2func([PSMP.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
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
% Build
%===============================================================================

%---------------------------------------------
% Test Quantization
%---------------------------------------------
qT0 = (0:SYS.GradSampBase/1000:PROJdgn.tro);
ind = find(qT0 == PROJdgn.tro);
if ind == 0
    err.flag = 1;
    err.msg = 'Tro not a multiple of System Gseg';
    return
end
GQNT.divno = 1;
GQNT.mingseg = SYS.GradSampBase/1000;
GQNT.gseg = SYS.GradSampBase/1000;

%------------------------------------------
% Generate
%------------------------------------------
func = str2func([IMPTYPE.method,'_Func']);      
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qT0;
INPUT.GQNT = GQNT;
INPUT.PSMP = PSMP;
INPUT.func = 'Generate';     
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
GQKSA0 = IMPTYPE.GQKSA0;
clear INPUT;

%------------------------------------------
% ORNT 
%------------------------------------------
ORNT.dimx = PROJdgn.vox;
ORNT.dimy = PROJdgn.vox;   
ORNT.dimz = PROJdgn.vox; 

%------------------------------------------
% Finish
%------------------------------------------
func = str2func([IMPTYPE.method,'_Func']);      
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.GQKSA0 = GQKSA0;
INPUT.qT0 = qT0;
INPUT.SYS = SYS;
INPUT.SYSRESP = SYSRESP;
INPUT.TEND = TEND;
INPUT.TST = TST;
INPUT.GQNT = GQNT;
INPUT.func = 'Finish';     
[IMPTYPE,err] = func(IMPTYPE,INPUT);
if err.flag
    return
end
clear INPUT;
Gtot = IMPTYPE.Gtot;
qTtot = IMPTYPE.qTtot;
qT = IMPTYPE.qT;
GQKSA = IMPTYPE.GQKSA;
GWFM = IMPTYPE.GWFM;

%----------------------------------------------------
% Save
%----------------------------------------------------
IMETH.Gscnr = Gtot;
IMETH.qTscnr = qTtot;
IMETH.tgwfm = GWFM.tgwfm;

%----------------------------------------------------
% Hz/pix
%----------------------------------------------------
% ProjectedReadoutDurationAt03ms = 0.3*(PROJdgn.kmax/TIMADJ.kRadAt03ms);
% TIMADJ.HzPerPix03ms = 1000*1/ProjectedReadoutDurationAt03ms;
% ProjectedReadoutDurationAt1ms = 1.0*(PROJdgn.kmax/TIMADJ.kRadAt1ms);
% TIMADJ.HzPerPix1ms = 1000*1/ProjectedReadoutDurationAt1ms;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
GwfmPanel(1,:) = {'GmaxChan (amp)',GWFM.GmaxScnrChan,'Output'};
GwfmPanel(2,:) = {'tgwfm (ms)',IMETH.tgwfm,'Output'};

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
INPUT.func = 'PostResample';
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
    fhk = figure(3000); clf;
    if strcmp(fhk.NumberTitle,'on')
        fhk.Name = 'kSpace Sampling';
        fhk.NumberTitle = 'off';
        fhk.Position = [200+TST.figshift 150 1400 800];
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
    clrarr = {'r','b','g'};
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
        KendMag = sqrt(Kend(:,1,1).^2 + Kend(:,1,2).^2 + + Kend(:,1,3).^2);
        plot(KendMag,'k');
    end
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Trajectory End');

    subplot(2,3,5); hold on;
    ind1 = find(abs(Kend(:,1,1)) == max(abs(Kend(:,1,1))));
    ind2 = find(abs(Kend(:,1,2)) == max(abs(Kend(:,1,2))));
    ind3 = find(abs(Kend(:,1,3)) == max(abs(Kend(:,1,3))));
    plot(Samp0,Kmat0(ind1,:,1),'b');
    plot(Samp0,Kmat0(ind2,:,2),'g');
    plot(Samp0,Kmat0(ind3,:,3),'r');
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Waveforms with Greatest kEnd');
end    
Kmat = KmatRecon;
samp = SampRecon;

%---------------------------------------------
% Test
%---------------------------------------------
maxKend = max(abs(Kend(:)));    
meanKend = mean(KendMag);

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
KSMP.meanKend = meanKend;  

%----------------------------------------------------
% Panel
%----------------------------------------------------
KsmpPanel(1,:) = {'troTotal (ms)',KSMP.nproRecon*TSMP.dwell,'Output'};
KsmpPanel(2,:) = {'npro',KSMP.nproRecon,'Output'};
KsmpPanel(3,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
KsmpPanel(4,:) = {'ImageDelay (ms)',KSMP.Delay2Centre,'Output'};
KsmpPanel(5,:) = {'Spoil (rKmax)',KSMP.meanKend/PROJdgn.kmax,'Output'};

PanelSpace(1,:) = {'','','Output'};
if strcmp(TST.IMETH.panel,'basic') || strcmp(TST.IMETH.panel,'gslew')
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
    fh.Position = [200+TST.figshift 550 1400 400];
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
set(gca,'cameraposition',[-800 -1000 160]); 
clrarr = {'r','b','g'};
plot3(KmatDisplay(:,1,end),KmatDisplay(:,2,end),KmatDisplay(:,3,end),'k-');
if IMPTYPE.numberofimages > 1
    for n = 1:IMPTYPE.numberofimages
        plot3(KmatDisplay(:,1,n),KmatDisplay(:,2,n),KmatDisplay(:,3,n),clrarr{n},'linewidth',2);
    end
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
lim = 1.05*GWFM.GmaxScnrChan;
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
IMETH.GWFM = GWFM; 
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.KSMP = KSMP;
SYSRESP = rmfield(SYSRESP,{'Trecon','Grecon'}); 
IMETH.SYSRESP = SYSRESP;
IMETH.impPROJdgn = PROJdgn;
IMETH.PROJimp = PROJimp;
IMETH.ORNT = ORNT;
IMETH.CACC = struct();
IMETH.DESOL = struct();
IMETH.RADEV = struct();

Status2('done','',2);
Status2('done','',3);
    
    
