%====================================================
% (v1e)
%     - start from 'LR1_GenProj_v1e'
%====================================================

function [DES,err] = LR2_GenProj_v1e(INPUT)

Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DES.de = 'LR2_Sol_v1a';
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
PSMP = INPUT.PSMP;
TST = INPUT.TST;
clear INPUT;

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
tro = PROJdgn.tro;
reltheta = PROJdgn.reltheta;

%------------------------------------------
% Define Polar Angle Evolution Functions
%------------------------------------------
spincalcnprojfunc = SPIN.spincalcnprojfunc;
spincalcndiscsfunc = SPIN.spincalcndiscsfunc;
sphi = @(r) (2*(pi*rad)^2)/spincalcnprojfunc(r);      
stheta = @(r) (pi*rad)/spincalcndiscsfunc(r);  

%------------------------------------------
% Setup Differection Equation Solver
%------------------------------------------
options = odeset('RelTol',5e-14,'AbsTol',[5e-14,5e-14,5e-14]);
defunc = str2func(DES.de);
tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
deradsolfunc = str2func(['@(r,p)' DESOL.RADEV.deradsolfunc]);
deradsolfunc = @(r) deradsolfunc(r,p);
phi0 = PSMP.phi;
theta0 = PSMP.theta;
KSA = zeros(length(phi0),DESOL.len,3);

%==========================================
% Solve
%==========================================
for n = 1:length(phi0) 

    %------------------------------------------
    % Solve Differential Equations
    %------------------------------------------    
    Status2('busy',['Generate Trajectory Number: ',num2str(n)],2);
    if strcmp(TST.initstrght,'Yes')                     % testing option
        r1 = p;
        phi1 = phi0(n);
        theta1 = theta0(n);
    else
        [x,Y] = ode113(defunc,tau1,[p,phi0(n),theta0(n)],options,deradsolfunc,sphi,stheta,reltheta); 
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
    
    r = [0 flipdim(r1,2) real(Y(2:length(tau2),1))'];
    phi = [0 flipdim(phi1,2) real(Y(2:length(tau2),2))']; 
    theta = [0 flipdim(theta1,2) real(Y(2:length(tau2),3))'];
    
    if round(max(r)*250)/250 < 1    
        test = max(r)
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
    % Save
    %------------------------------------------    
    KSA(n,:,:) = kArr;
end

%------------------------------------------
% Return
%------------------------------------------    
DES.projlen0 = projlen0;
DES.T = TArr;
DES.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);



