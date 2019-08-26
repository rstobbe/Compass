%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_OutInOutMultiEcho_v1a_Func(IMPTYPE,INPUT)

Status2('busy','Create OutInOut Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%IMPTYPE.radslowfact = 50;
%IMPTYPE.spinslowfact = 11;
IMPTYPE.radslowfact = 25;
IMPTYPE.spinslowfact = 5;
IMPTYPE.maxradderivative = 0.02;

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
    % Quaternion
    %---------------------------------------------
    Q = [0,KSA(1,end,1),KSA(1,end,2),KSA(1,end,3)];                % 180 rotation Quaternion
    Q = Q/norm(Q);
    Qmat = [Q(1)^2+Q(2)^2-Q(3)^2-Q(4)^2     2*(Q(2)*Q(3)+Q(1)*Q(4))         2*(Q(2)*Q(4)-Q(1)*Q(3)); ...
            2*(Q(2)*Q(3)-Q(1)*Q(4))         Q(1)^2-Q(2)^2+Q(3)^2-Q(4)^2     2*(Q(3)*Q(4)+Q(1)*Q(2)); ...
            2*(Q(2)*Q(4)+Q(1)*Q(3))         2*(Q(3)*Q(4)-Q(1)*Q(2))         Q(1)^2-Q(2)^2-Q(3)^2+Q(4)^2];

    %---------------------------------------------
    % Rotate
    %---------------------------------------------
    rKSA = zeros(size(KSA));
    for n = 1:nproj
        tKSA = squeeze(KSA(n,:,:));
        rKSA(n,:,:) = tKSA*Qmat;
    end

    %---------------------------------------------
    % Return
    %---------------------------------------------
    IMPTYPE.KSA = cat(2,KSA,flip(rKSA(:,1:end-1,:),2),KSA);
    IMPTYPE.T = [T T(end)+T(2:end) 2*T(end)+T(2:end) 3*T(end)+T(2)];
    
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
    
end





    