%====================================================
% (v1i)
%     - parfor implementation
%====================================================

function [OUTPUT,err] = LR1_GenProj_v1i(INPUT)

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
OUTPUT = struct();

%---------------------------------------------
% DE Functions
%---------------------------------------------
defuncIn = str2func('LR1_InSol_v1c');
defuncOut = str2func('LR1_OutSol_v1c');

%---------------------------------------------
% Test
%---------------------------------------------
TST.initstrght = 'No';
if not(isfield(SPIN,'CentSpinFact'))
    err.flag = 1;
    err.msg = 'Use Updated Spin Function with ''CentSpinFact''';
    return
end

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
    kArrX = zeros(length(phi0),length(tau2)+1);
    kArrY = zeros(length(phi0),length(tau2)+1);
    kArrZ = zeros(length(phi0),length(tau2)+1);    
else
    KSA = zeros(length(phi0),DESOL.len,3);
    kArrX = zeros(length(phi0),DESOL.len);
    kArrY = zeros(length(phi0),DESOL.len);
    kArrZ = zeros(length(phi0),DESOL.len);   
end
    
%==================================================
% Solve
%==================================================
initstrght = TST.initstrght;
haderror = 0;
divs = 500;
tic;
for m = 1:ceil(length(phi0)/divs)
    if m*divs < length(phi0)
        narray = (m-1)*divs+1:m*divs;
    else
        narray = (m-1)*divs+1:length(phi0);
    end
    Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
    parfor n = narray 
        if strcmp(initstrght,'Yes')                     % testing option
            r1 = p;
            phi1 = phi0(n);
            theta1 = theta0(n);
        else
            [x,Y] = ode113(defuncIn,tau1,[p,phi0(n),theta0(n)],options,deradsolinfunc,sphi,stheta,p,SPIN); 
            r1 = real(Y(:,1))';  
            phi1 = real(Y(:,2))'; 
            theta1 = real(Y(:,3))';
            if length(x) ~= length(tau1)
                error('AbsTol set to values that are too small');
            end
            if r1(length(r1)) < 0
                haderror(n) = 1;
            end
        end
        [x,Y] = ode113(defuncOut,tau2,[p,phi0(n),theta0(n)],options,deradsoloutfunc,sphi,stheta,p,SPIN);
        r = [0 flip(r1,2) real(Y(2:length(tau2),1))'];
        phi = [0 flip(phi1,2) real(Y(2:length(tau2),2))']; 
        theta = [0 flip(theta1,2) real(Y(2:length(tau2),3))'];
        kArrX(n,:) = r.*cos(theta).*sin(phi);                              
        kArrY(n,:) = r.*sin(theta).*sin(phi);
        kArrZ(n,:) = r.*cos(phi);   
    end
end
if sum(haderror) > 0
    err.flag = 1;
    err.msg = 'Negative DE Solution Problem. Adjust DE solution timing';
end
ProjGenTime = toc

%------------------------------------------
% Consolidate
%------------------------------------------    
KSA(:,:,1) = kArrX;
KSA(:,:,2) = kArrY;
KSA(:,:,3) = kArrZ;

%------------------------------------------
% Calculate Real Timings
%------------------------------------------
if strcmp(initstrght,'Yes')
    tautot = p+[-p tau2(1:length(tau2))];
else
    tautot = (DESOL.plin)+[-(DESOL.plin) flip(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis
end   
%projlenOld = tautot(end);
projlen0 = DESOL.plin+DESOL.plout;
TArr = (tautot/projlen0)*tro;

%------------------------------------------
% Return
%------------------------------------------    
OUTPUT.projlen0 = projlen0;
OUTPUT.T = TArr;
OUTPUT.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);



