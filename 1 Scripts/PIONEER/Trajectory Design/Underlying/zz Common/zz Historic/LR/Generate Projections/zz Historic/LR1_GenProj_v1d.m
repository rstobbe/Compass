%====================================================
% (v1d)
%     - ode precision change
%====================================================

function [DES,err] = LR1_GenProj_v1d(INPUT)

Status('busy','Create LR Trajectories');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DES.de = 'LR1_Sol_v1a';
if not(exist(DES.de,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
SPIN = INPUT.SPIN;
DESOL = INPUT.DESOL;
CACC = INPUT.CACC;
PSMP = INPUT.PSMP;
TST = INPUT.TST;
clear INPUT;

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
tro = PROJdgn.tro;

%------------------------------------------
% Get LR spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([PROJdgn.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;
spincalcnprojfunc = SPIN.spincalcnprojfunc;
spincalcndiscsfunc = SPIN.spincalcndiscsfunc;
SPIN = rmfield(SPIN,'spincalcnprojfunc');       % wont save nice
SPIN = rmfield(SPIN,'spincalcndiscsfunc');

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TST = TST;
func = str2func([PROJdgn.desoltimfunc,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Define Polar Angle Evolution Functions
%------------------------------------------
sphi = @(r) (2*(pi*rad)^2)/spincalcnprojfunc(r);      
stheta = @(r) (pi*rad)/spincalcndiscsfunc(r);  

%------------------------------------------
% Setup Differection Equation Solver
%------------------------------------------
options = odeset('RelTol',1e-14,'AbsTol',[1e-14,1e-14,1e-14]);
defunc = str2func(DES.de);
tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
deradsolfunc = str2func(['@(r,p)' DESOL.RADEV.deradsolfunc]);
deradsolfunc = @(r) deradsolfunc(r,p);
phi0 = PSMP.phi;
theta0 = PSMP.theta;

%------------------------------------------
% Setup Acceleration Contrain Function
%------------------------------------------
accconstfunc = str2func([PROJdgn.accconstfunc,'_Func']); 

%==========================================
% Solve
%==========================================
for n = 1:length(phi0) 

    %------------------------------------------
    % Solve Differential Equations
    %------------------------------------------    
    Status('busy',['Generate Trajectory Number: ',num2str(n)]);
    Status2('busy','Solve Differential Equations',2);
    if strcmp(TST.initstrght,'Yes')                     % testing option
        r1 = p;
        phi1 = phi0(n);
        theta1 = theta0(n);
    else
        [x,Y] = ode113(defunc,tau1,[p,phi0(n),theta0(n)],options,deradsolfunc,sphi,stheta); 
        %[x,Y] = ode45(defunc,tau1,[p,phi0(n),theta0(n)],options,deradsolfunc,sphi,stheta);
        r1 = real(Y(:,1))';  
        phi1 = real(Y(:,2))'; 
        theta1 = real(Y(:,3))';
        if length(x) ~= length(tau1)
            error('AbsTol set to values that are too small');
        end
        if r1(length(r1)) < 0
            last10rad = r1(length(r1)-10:length(r1))
            err.flag = 1;
            err.msg = 'Negative DE Solution Problem. Adjust DE solution timing';
            return
        end
    end
    [x,Y] = ode113(defunc,tau2,[p,phi0(n),theta0(n)],options,deradsolfunc,sphi,stheta);
    %[x,Y] = ode45(defunc,tau2,[p,phi0(n),theta0(n)],options,deradsolfunc,sphi,stheta);
    
    r = [0 flipdim(r1,2) real(Y(2:length(tau2),1))'];
    phi = [0 flipdim(phi1,2) real(Y(2:length(tau2),2))']; 
    theta = [0 flipdim(theta1,2) real(Y(2:length(tau2),3))'];
    
    if round(max(r)*1000)/1000 < 1
        error('DE Not Solved to End of Trajectory');
    end

    %------------------------------------------
    % Calculate k-Space Array
    %------------------------------------------
    slvno = length(r);
    kArr(:,1) = r.*cos(theta).*sin(phi);                              
    kArr(:,2) = r.*sin(theta).*sin(phi);
    kArr(:,3) = r.*cos(phi);

    %------------------------------------------
    % Calculate k-Space Array Inital Portion
    %------------------------------------------
    %r1 = flipdim(r1,2);
    %phi1 = flipdim(phi1,2);
    %theta1 = flipdim(theta1,2);
    %kArr1(:,1) = r1.*cos(theta1).*sin(phi1);                              
    %kArr1(:,2) = r1.*sin(theta1).*sin(phi1);
    %kArr1(:,3) = r1.*cos(phi1);    
    %figure(100); hold on;
    %plot(kArr);
    %plot(kArr1,'linewidth',2);
    
    %------------------------------------------
    % Calculate Real Timings
    %------------------------------------------
    if strcmp(TST.initstrght,'Yes')
        tautot = p+[-p flipdim(tau1,2) tau2(2:length(tau2))];
    else
        tautot = (DESOL.plin)+[-(DESOL.plin) flipdim(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis
    end    
    projlen0 = tautot(slvno);
    realT = (1/projlen0)*tro;
    TArr = tautot*realT;

    %------------------------------------------
    % Constrain Accelerations
    %------------------------------------------    
    clear INPUT;
    INPUT.r = r;
    INPUT.kArr = kArr;
    INPUT.TArr = TArr;
    INPUT.PROJdgn = PROJdgn;
    INPUT.TST = TST;
    CACC.projlen0 = projlen0;
    [CACC,err] = accconstfunc(CACC,INPUT);
    if err.flag == 1
        return
    end
    clear INPUT;   
    TArrC = CACC.TArr;
    kArrC = CACC.kArr;
    
    %------------------------------------------
    % Save
    %------------------------------------------    
    if n == 1 
        KSA = zeros(length(phi0),length(TArrC),3);
        T = zeros(length(phi0),length(TArrC));
    end
    T(n,:) = TArrC;
    KSA(n,:,:) = kArrC;
end

%------------------------------------------
% Return
%------------------------------------------    
DES.SPIN = SPIN;
DES.DESOL = DESOL;
DES.CACC = CACC;
DES.T = T;
DES.KSA = KSA;
    
Status('done','');
Status2('done','',2);
Status2('done','',3);



