%====================================================
% (v1f)
%     - use 'LR1_InSol_v1b' & 'LR1_OutSol_v1b' functions
%====================================================

function [DES,err] = LR1_GenProj_v1f(INPUT)

Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

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
% DE Functions
%---------------------------------------------
defuncIn = str2func('LR1_InSol_v1b');
defuncOut = str2func('LR1_OutSol_v1b');

%---------------------------------------------
% Test
%---------------------------------------------
TST.initstrght = 'No';

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
tro = PROJdgn.tro;

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
tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
deradsolinfunc = str2func(['@(r,p)' DESOL.RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,p);
deradsoloutfunc = str2func(['@(r,p)' DESOL.RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,p);
phi0 = PSMP.phi;
theta0 = PSMP.theta;
if strcmp(TST.initstrght,'Yes') 
    KSA = zeros(length(phi0),length(tau2)+1,3);
else
    KSA = zeros(length(phi0),DESOL.len,3);
end
    
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
        [x,Y] = ode113(defuncIn,tau1,[p,phi0(n),theta0(n)],options,deradsolinfunc,sphi,stheta,p); 
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
    [x,Y] = ode113(defuncOut,tau2,[p,phi0(n),theta0(n)],options,deradsoloutfunc,sphi,stheta,p);
    
    r = [0 flip(r1,2) real(Y(2:length(tau2),1))'];
    phi = [0 flip(phi1,2) real(Y(2:length(tau2),2))']; 
    theta = [0 flip(theta1,2) real(Y(2:length(tau2),3))'];
    
    %if round(max(r)*1000)/1000 < 1
    if round(max(r)*500)/500 < 1
    %if round(max(r)*250)/250 < 1    
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
        tautot = p+[-p tau2(1:length(tau2))];
    else
        tautot = (DESOL.plin)+[-(DESOL.plin) flip(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis
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



