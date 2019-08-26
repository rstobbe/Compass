%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_OutInDualEcho_v1b_Func(IMPTYPE,INPUT)

Status2('busy','Create OutInOut Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(INPUT.loc,'PreDeSolTim')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    CLR = INPUT.CLR;
    SPIN = INPUT.SPIN;
    RADEV = INPUT.DESOL.RADEV;
    PROJdgn = INPUT.PROJdgn;    
    clear INPUT;
   
    %---------------------------------------------
    % Get radial evolution function 
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    func = str2func([RADEV.method,'_Func']);           
    [RADEV,err] = func(RADEV,INPUT);
    if err.flag
        return
    end
    clear INPUT;    
    
    %------------------------------------------
    % Define Spinning Speeds
    %------------------------------------------
    stheta = @(r) 1/SPIN.spincalcndiscsfunc(r);  
    sphi = @(r) 1/SPIN.spincalcnspokesfunc(r);     

    %------------------------------------------
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
    deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);
    
    %---------------------------------------------
    % Create DESTRCT
    %---------------------------------------------
    IMPTYPE.DESTRCT.stheta = stheta;
    IMPTYPE.DESTRCT.sphi = sphi;
    IMPTYPE.DESTRCT.p = PROJdgn.p;
    IMPTYPE.DESTRCT.rad = PROJdgn.rad;
    IMPTYPE.DESTRCT.radslowfact = IMPTYPE.radslowfact;
    IMPTYPE.DESTRCT.spinslowfact = IMPTYPE.spinslowfact;
    IMPTYPE.DESTRCT.deradsoloutfunc = deradsoloutfunc;
    IMPTYPE.DESTRCT.deradsolinfunc = deradsolinfunc;
    
    %---------------------------------------------
    % Create Radial Evolution Functions
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;   
    IMPTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);
    
    %---------------------------------------------
    % Determine How Far to Solve
    %---------------------------------------------
    n = 1;
    for r = 1:0.000001:2
        dr(n) = IMPTYPE.radevout(0,r);
        if dr(n) < IMPTYPE.maxradderivative
            break
        end
        n = n+1;
    end
    %----
    figure(1235123); hold on;
    plot((1:0.000001:r),dr);
    ylabel('dr');
    xlabel('radius');
    title('Evolution Slow Down');
    %----
    
    IMPTYPE.MaxRadSolve = r;

    %---------------------------------------------
    % General
    %---------------------------------------------    
    IMPTYPE.solutions = 2;
    
%=================================================================
% PreGeneration
%=================================================================
elseif strcmp(INPUT.loc,'PreGeneration')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    CLR = INPUT.CLR;
    DESOL = INPUT.DESOL;
    clear INPUT;
    
    %---------------------------------------------
    % Create DEs
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.dir = 1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    
    %---------------------------------------------
    % Solution Values
    %---------------------------------------------    
    IMPTYPE.rad0 = PROJdgn.p;
    IMPTYPE.phi0 = PSMP.phi;
    IMPTYPE.theta0 = PSMP.theta;
    IMPTYPE.tau1 = DESOL.tau1;
    IMPTYPE.tau2 = DESOL.tau2;
    IMPTYPE.len = DESOL.len;
    IMPTYPE.dir = 1;    
    
%=================================================================
% PreGeneration2
%=================================================================
elseif strcmp(INPUT.loc,'PreGeneration2')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    StartVals = INPUT.StartVals;
    CLR = INPUT.CLR;
    DESOL = INPUT.DESOL;
    clear INPUT;
    
    %---------------------------------------------
    % Create DEs
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.dir = -1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    
    %---------------------------------------------
    % Solution Values
    %---------------------------------------------    
    IMPTYPE.rad0 = StartVals(:,1);
    IMPTYPE.phi0 = StartVals(:,2);
    IMPTYPE.theta0 = StartVals(:,3);
    IMPTYPE.tau1 = DESOL.tau1;
    IMPTYPE.tau2 = flip(DESOL.tau2(end)-DESOL.tau2);
    IMPTYPE.len = DESOL.len;
    IMPTYPE.dir = -1;     
    
%=================================================================
% PostGeneration
%=================================================================
elseif strcmp(INPUT.loc,'PostGeneration')
    
    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    KSA = INPUT.KSA;
    T = INPUT.T; 
    PROJdgn = INPUT.PROJdgn;
    nproj = length(KSA(:,1,1));
    clear INPUT;
    
    %---------------------------------------------
    % Add Zeros
    %---------------------------------------------    
    step = T(2);
    nzeros = (IMPTYPE.postdelay/1000)/step;
    zeroadd = zeros(nproj,nzeros,3);
    zerotiming = (step:step:nzeros*step);
    
    %---------------------------------------------
    % Return
    %---------------------------------------------
    IMPTYPE.KSA = cat(2,KSA,zeroadd);
    IMPTYPE.T = [T T(end)+zerotiming];
    IMPTYPE.start2est = T(end)-PROJdgn.tro;
    
    %figure(12341234)
    %plot(IMPTYPE.T)
    
    figure(500);
    subplot(2,3,5); hold on;
    plot(IMPTYPE.T,PROJdgn.rad*IMPTYPE.KSA(1,:,1),'k');
    plot(T,PROJdgn.rad*KSA(1,:,1),'b');
    plot(IMPTYPE.T,PROJdgn.rad*IMPTYPE.KSA(1,:,2),'k');
    plot(T,PROJdgn.rad*KSA(1,:,2),'g');
    plot(IMPTYPE.T,PROJdgn.rad*IMPTYPE.KSA(1,:,3),'k');
    plot(T,PROJdgn.rad*KSA(1,:,3),'r');
    plot(T,zeros(size(T)),'k:');
    xlabel('(ms)'); ylabel('kSpace (steps)'); title('kSpace Test');   

%=================================================================
% PreDeSolTim
%=================================================================
elseif strcmp(INPUT.loc,'PostResample')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJimp = INPUT.PROJimp;
    Samp0 = INPUT.Samp0;
    Kmat0 = INPUT.Kmat0;
    SampRecon0 = INPUT.SampRecon;
    KmatRecon0 = INPUT.KmatRecon;
    qTrecon = INPUT.qTrecon;
    Grecon = INPUT.Grecon;
    npro = length(SampRecon0);
    nptot = length(Samp0);
    KSMP = INPUT.KSMP;
    TSMP = INPUT.TSMP;
    clear INPUT

	figure(5963455); clf; hold on;
    Rad0 = sqrt(Kmat0(1,:,1).^2 + Kmat0(1,:,2).^2 + Kmat0(1,:,3).^2);
    plot(Rad0,'k');
       
    KmatRecon = zeros([size(KmatRecon0) 2]);
    KmatRecon(:,:,:,1) = KmatRecon0;    
    KmatDisplay = NaN*ones([nptot 3 3]);
    ind = find(round(Samp0*1e6) == round(SampRecon0(1)*1e6));
    KmatDisplay(ind:ind+npro-1,:,1) = squeeze(KmatRecon(1,:,:,1));
    
    %---------------------------------------------
    % Fit 1st Image
    %---------------------------------------------
    tKmatRecon = squeeze(KmatRecon0(1,:,:));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = 1:1:50;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart1 = ind(residsum == min(residsum));
    if residsum(SampStart1) ~= 0
        error
    end
    plot([NaN*ones(SampStart1-1,1);Rad0],'r','linewidth',2);
    
    %---------------------------------------------
    % Fit 2nd Image
    %---------------------------------------------
%     %----
%     shift = 0.001;
%     %----
%     Samp0 = (shift:PROJimp.dwell:qTrecon(end)+shift); 
%     %Samp0 = (0:PROJimp.dwell:qTrecon(end));  
%     [Kmat0,Kend] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),Samp0-qTrecon(1),PROJimp.gamma);                % negative time fixup    
        
    tKmatRecon = squeeze(flip(KmatRecon0(1,:,:),2));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = find(Samp0 >= IMPTYPE.start2est);
    ind = ind-10:1:ind+20;
    residsum = [];
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart2 = ind(residsum == min(residsum));
    plot([NaN*ones(SampStart2-1,1);Rad0],'r','linewidth',2);
    
    KmatRecon(:,:,:,2) = flip(Kmat0(:,SampStart2:SampStart2+npro-1,:),2);
    KmatDisplay(SampStart2:SampStart2+npro-1,:,2) = Kmat0(1,SampStart2:SampStart2+npro-1,:);
    KmatDisplay(1:SampStart2+npro-1,:,3) = Kmat0(1,1:SampStart2+npro-1,:);
    
    IMPTYPE.SampStart = [SampStart1 SampStart2];
    IMPTYPE.KmatRecon = KmatRecon;
    IMPTYPE.KmatDisplay = KmatDisplay;
    IMPTYPE.numberofimages = 2;
   
    %---------------------------------------------
    % Return Relavent to KSMP Structure
    %---------------------------------------------    
    KSMP.SampStart = IMPTYPE.SampStart;
    CenSamp = KSMP.SampStart;
    CenSamp(2) = CenSamp(2) + npro-1;
    KSMP.Delay2Centre = Samp0(CenSamp);
    KSMP.flip = [0 1];
    IMPTYPE.KSMP = KSMP;

    %---------------------------------------------
    % Increase Tro to accomodate any gradient delay (Siemens)
    %---------------------------------------------
    troProt = TSMP.dwellProt*ceil(KSMP.Delay2Centre(2)/TSMP.dwellProt);
    nproProt = troProt/TSMP.dwellProt;
    extraptsProt = TSMP.minextraptsProt;
    while true
        totpts = (nproProt+extraptsProt)*TSMP.sysoversamp;
        if rem(totpts,2) == 0                         % make sure number of data points is a multiple of 2                            
            break
        else
            extraptsProt = extraptsProt+1;
        end
    end    
    
    %---------------------------------------------
    % Return Relavent to TSMP Structure
    %---------------------------------------------       
    TSMP.troProt = TSMP.dwellProt*(nproProt+extraptsProt);
    TSMP.troMag = TSMP.dwell*(totpts);
    TSMP.nproProt = nproProt+extraptsProt;  
    TSMP.nproMag = totpts;
    IMPTYPE.TSMP = TSMP;
       
end
    









    