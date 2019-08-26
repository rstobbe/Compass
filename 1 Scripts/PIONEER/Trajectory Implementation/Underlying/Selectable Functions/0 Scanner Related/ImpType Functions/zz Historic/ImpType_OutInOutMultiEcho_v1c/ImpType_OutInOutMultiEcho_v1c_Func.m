%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_OutInOutMultiEcho_v1c_Func(IMPTYPE,INPUT)

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
    % Create Basic Defuncs
    %---------------------------------------------
    INPUT.stheta = stheta;
    INPUT.sphi = sphi;
    INPUT.p = PROJdgn.p;
    INPUT.rad = PROJdgn.rad;
    INPUT.deradsolfunc = deradsoloutfunc;
    INPUT.radslowfact = IMPTYPE.radslowfact;
    INPUT.spinslowfact = IMPTYPE.spinslowfact;
    IMPTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    IMPTYPE.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);

    INPUT.deradsolfunc = deradsolinfunc;   
    IMPTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);
    IMPTYPE.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);
    
    %---------------------------------------------
    % Determine How Far to Solve
    %---------------------------------------------
    for r = 1:0.001:2
        dr = IMPTYPE.radevout(0,r);
        if dr < IMPTYPE.maxradderivative
            break
        end
    end
    IMPTYPE.MaxRadSolve = r;        

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
    % Rotate (Quaternion based)
    %---------------------------------------------
    rKSA = zeros(size(KSA));
    for n = 1:nproj
        Q = [0,KSA(n,end,1),KSA(n,end,2),KSA(n,end,3)];                % 180 rotation Quaternion
        Q = Q/norm(Q);
        Qmat = [Q(1)^2+Q(2)^2-Q(3)^2-Q(4)^2     2*(Q(2)*Q(3)+Q(1)*Q(4))         2*(Q(2)*Q(4)-Q(1)*Q(3)); ...
                2*(Q(2)*Q(3)-Q(1)*Q(4))         Q(1)^2-Q(2)^2+Q(3)^2-Q(4)^2     2*(Q(3)*Q(4)+Q(1)*Q(2)); ...
                2*(Q(2)*Q(4)+Q(1)*Q(3))         2*(Q(3)*Q(4)-Q(1)*Q(2))         Q(1)^2-Q(2)^2-Q(3)^2+Q(4)^2];

        tKSA = squeeze(KSA(n,:,:));
        rKSA(n,:,:) = tKSA*Qmat;
    end

    %---------------------------------------------
    % Return
    %---------------------------------------------
    IMPTYPE.KSA = cat(2,KSA,flip(rKSA(:,1:end-1,:),2),KSA);
    IMPTYPE.T = [T T(end)+T(2:end) 2*T(end)+T(2:end) 3*T(end)+T(2)];
    IMPTYPE.start2est = 2*T(end)-PROJdgn.tro;
    IMPTYPE.start3est = 2*T(end);
    
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
    Samp0 = INPUT.Samp0;
    Kmat0 = INPUT.Kmat0;
    SampRecon0 = INPUT.SampRecon;
    KmatRecon0 = INPUT.KmatRecon;
    npro = length(SampRecon0);
    nptot = length(Samp0);
    KSMP = INPUT.KSMP;
    clear INPUT

    KmatRecon = zeros([size(KmatRecon0) 3]);
    KmatRecon(:,:,:,1) = KmatRecon0;    
    KmatDisplay = NaN*ones([nptot 3 4]);
    ind = find(round(Samp0*1e6) == round(SampRecon0(1)*1e6));
    KmatDisplay(ind:ind+npro-1,:,1) = squeeze(KmatRecon(1,:,:,1));
    
    %---------------------------------------------
    % Fit 1st Image
    %---------------------------------------------
    tKmatRecon = squeeze(KmatRecon0(1,:,:));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = 1:1:30;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
%         figure(5963456);
%         clf; hold on;
%         plot(Rad0,'r','linewidth',2);
%         plot(Rad1,'k','linewidth',1);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart1 = ind(residsum == min(residsum));
    if residsum(SampStart1) ~= 0
        error
    end
    
    %---------------------------------------------
    % Fit 2nd Image
    %---------------------------------------------
    tKmatRecon = squeeze(flip(KmatRecon0(1,:,:),2));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = find(Samp0 >= IMPTYPE.start2est);
    ind = ind-10:1:ind+20;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
%         figure(5963456);
%         clf; hold on;
%         plot(Rad0,'r','linewidth',2);
%         plot(Rad1,'k','linewidth',1);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart2 = ind(residsum == min(residsum));
    KmatRecon(:,:,:,2) = flip(Kmat0(:,SampStart2:SampStart2+npro-1,:),2);
    KmatDisplay(SampStart2:SampStart2+npro-1,:,2) = Kmat0(1,SampStart2:SampStart2+npro-1,:);
    
    %---------------------------------------------
    % Fit 3rd Image
    %---------------------------------------------
    tKmatRecon = squeeze(KmatRecon0(1,:,:));
    Rad0 = sqrt(tKmatRecon(:,1).^2 + tKmatRecon(:,2).^2 + tKmatRecon(:,3).^2);
    ind = find(Samp0 >= IMPTYPE.start3est);
    ind = ind-10:1:ind+20;
    for n = 1:length(ind)
        tKmat0 = squeeze(Kmat0(1,ind(n):ind(n)+npro-1,:));
        Rad1 = sqrt(tKmat0(:,1).^2 + tKmat0(:,2).^2 + tKmat0(:,3).^2);
%         figure(5963456);
%         clf; hold on;
%         plot(Rad0,'r','linewidth',2);
%         plot(Rad1,'k','linewidth',1);
        resid = Rad0 - Rad1;
        residsum(n) = sum(abs(resid(:)));
    end
    SampStart3 = ind(residsum == min(residsum));
    KmatRecon(:,:,:,3) = Kmat0(:,SampStart3:SampStart3+npro-1,:);    
    KmatDisplay(SampStart3:SampStart3+npro-1,:,3) = Kmat0(1,SampStart3:SampStart3+npro-1,:);
    KmatDisplay(1:SampStart3+npro-1,:,4) = Kmat0(1,1:SampStart3+npro-1,:);
    
    IMPTYPE.SampStart = [SampStart1 SampStart2 SampStart3];
    IMPTYPE.KmatRecon = KmatRecon;
    IMPTYPE.KmatDisplay = KmatDisplay;
    IMPTYPE.numberofimages = 3;
   
%     RadTest = squeeze(sqrt(KmatRecon(1,:,1,:).^2 + KmatRecon(1,:,2,:).^2 +KmatRecon(1,:,3,:).^2));
%     figure(5963456);
%     clf; hold on;
%     plot(RadTest(:,1),'k','linewidth',1);
%     plot(RadTest(:,2),'r','linewidth',1);
%     plot(RadTest(:,3),'b','linewidth',1);

    %---------------------------------------------
    % Return Relavent to KSMP Structure
    %---------------------------------------------    
    KSMP.SampStart = IMPTYPE.SampStart;
    CenSamp = KSMP.SampStart;
    CenSamp(2) = CenSamp(2) + npro-1;
    KSMP.Delay2Centre = Samp0(CenSamp);
    KSMP.flip = [0 1 0];
    IMPTYPE.KSMP = KSMP;
    
end
    









    