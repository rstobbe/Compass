%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_OutInDualEcho_v1c_Func(IMPTYPE,INPUT)

Status2('busy','Create OutInOut Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

Func = INPUT.func;
IMPTYPE.name = 'DEOI';

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(Func,'PreDeSolTim')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    DESTYPE = INPUT.DESTYPE;
    CLR = INPUT.CLR;
    RADEV = INPUT.DESOL.RADEV;
    PROJdgn = INPUT.PROJdgn;    
    TURNSOL = DESTYPE.TURNSOL;
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
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
    deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);
    
    %---------------------------------------------
    % Update DESTRCT for implementation
    %---------------------------------------------
    IMPTYPE.DESTRCT = DESTYPE.DESTRCT;
    IMPTYPE.DESTRCT.deradsoloutfunc = deradsoloutfunc;
    IMPTYPE.DESTRCT.deradsolinfunc = deradsolinfunc;
    
    %---------------------------------------------
    % Create Radial Evolution Functions
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
    INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;   
    IMPTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);
    
    %---------------------------------------------
    % Determine Radius Solution
    %---------------------------------------------
    func = str2func([TURNSOL.method,'_Func']);      
    INPUT.DESTYPE = IMPTYPE;     
    [TURNSOL,err] = func(TURNSOL,INPUT);
    if err.flag
        return
    end
    clear INPUT;    
    IMPTYPE.TURNSOL = TURNSOL;
    IMPTYPE.MaxRadSolve = TURNSOL.MaxRadSolve; 
    if IMPTYPE.MaxRadSolve ~= DESTYPE.MaxRadSolve
        error               % out evolution change?
    end          
    
%=================================================================
% PreGeneration
%=================================================================
elseif strcmp(Func,'PreGeneration')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    DESOL = INPUT.DESOL;
    CLR = INPUT.CLR;
    DESTYPE = INPUT.DESTYPE;
    clear INPUT;
    
    %---------------------------------------------
    % Create 'Out from Centre' Structure
    %---------------------------------------------
    INPUT = IMPTYPE.DESTRCT;
    INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
    INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
    INPUT.dir = 1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.SLVOUT.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.SLVOUT.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    IMPTYPE.SLVOUT.tau1 = DESOL.tau1;
    IMPTYPE.SLVOUT.tau2 = DESOL.tau2;
    IMPTYPE.SLVOUT.len = DESOL.len;   

    %---------------------------------------------
    % Create 'Return to Centre' Structure
    %---------------------------------------------    
    INPUT.dir = -1;
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsoloutfunc;
    IMPTYPE.SLVRET.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = IMPTYPE.DESTRCT.deradsolinfunc;     
    IMPTYPE.SLVRET.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    IMPTYPE.SLVRET.tau1 = DESOL.tau1;
    IMPTYPE.SLVRET.tau2 = flip(DESOL.tau2(end)-DESOL.tau2);
    IMPTYPE.SLVRET.len = DESOL.len;    
    
%=================================================================
% GenerateOut
%=================================================================
elseif strcmp(Func,'GenerateOut')

    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    GENPRJ = INPUT.GENPRJ;
    DESOL = INPUT.DESOL;
    clear INPUT;

    %---------------------------------------------
    % Generate outward portion
    %---------------------------------------------
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = PROJdgn.p;
    INPUT.phi0 = PSMP.phi;
    INPUT.theta0 = PSMP.theta;
    INPUT.dir = 1;
    INPUT.DESTYPE = IMPTYPE;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    IMPTYPE.T = DESOL.T;
    IMPTYPE.KSA = GENPRJ.KSA;       

%=================================================================
% GenerateFull
%=================================================================
elseif strcmp(Func,'GenerateFull')

    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    GENPRJ = INPUT.GENPRJ;
    TIMADJ = INPUT.TIMADJ;
    DESOL = INPUT.DESOL;
    clear INPUT;

    %---------------------------------------------
    % Generate outward portion
    %---------------------------------------------
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = PROJdgn.p;
    INPUT.phi0 = PSMP.phi;
    INPUT.theta0 = PSMP.theta;
    INPUT.dir = 1;
    INPUT.DESTYPE = IMPTYPE;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA = GENPRJ.KSA;
    
    %------------------------------------------
    % Solve T at Evolution Constraint
    %------------------------------------------
    Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
    Rad = mean(Rad,1);
    if strcmp(TIMADJ.CACC.doconstraint,'Yes')
        T = interp1(TIMADJ.ConstEvolRad,TIMADJ.ConstEvolT,Rad,'spline');
    end
    testtro = interp1(Rad,T,1,'spline'); 
    if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
        error
    end

    %---------------------------------------------
    % Generate return portion
    %---------------------------------------------    
    func = str2func([GENPRJ.method,'_Func']);    
    INPUT.rad0 = GENPRJ.EndVals(:,1);
    INPUT.phi0 = GENPRJ.EndVals(:,2);
    INPUT.theta0 = GENPRJ.EndVals(:,3);
    INPUT.dir = -1;
    INPUT.DESTYPE = IMPTYPE;
    [GENPRJ,err] = func(GENPRJ,INPUT);
    if err.flag
        return
    end
    clear INPUT; 
    KSA2 = GENPRJ.KSA;

    %------------------------------------------
    % Solve T at Evolution Constraint
    %------------------------------------------
    Rad2 = sqrt(KSA2(:,:,1).^2 + KSA2(:,:,2).^2 + KSA2(:,:,3).^2);
    Rad2 = mean(Rad2,1);
    if strcmp(TIMADJ.CACC.doconstraint,'Yes')
        T2 = interp1(TIMADJ.ConstEvolRad,TIMADJ.ConstEvolT,Rad2,'spline');
    end
    T2 = 2*T(end)-T2;

    %---------------------------------------------
    % Combine
    %---------------------------------------------
    IMPTYPE.T = [T T2];
    IMPTYPE.KSA = cat(2,KSA,KSA2);
    
%=================================================================
% PostGeneration
%=================================================================
elseif strcmp(Func,'PostGeneration')
    
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
elseif strcmp(Func,'PostResample')

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
    









    