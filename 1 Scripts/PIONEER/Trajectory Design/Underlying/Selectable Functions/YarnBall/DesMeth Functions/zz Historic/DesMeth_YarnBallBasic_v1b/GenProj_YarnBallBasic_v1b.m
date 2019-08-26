%=====================================================================
% (v1a)
%    
%=====================================================================

function [OUTPUT,err] = GenProj_YarnBallBasic_v1b(INPUT)

Status2('done','Generate YarnBall Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
SPIN = INPUT.SPIN;
RADEV = INPUT.RADEV;
DESOL = INPUT.DESOL;
PSMP = INPUT.PSMP;
CLR = INPUT.CLR;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
tro = PROJdgn.tro;

%------------------------------------------
% Define Spinning Speeds
%------------------------------------------
stheta = @(r) 1/SPIN.spincalcndiscsfunc(r);  
sphi = @(r) 1/SPIN.spincalcnspokesfunc(r);     

%------------------------------------------
% Setup Differection Equation Solver
%------------------------------------------
options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,p);
deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,p);

tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
phi0 = PSMP.phi;
theta0 = PSMP.theta;

KSA = zeros(length(phi0),DESOL.len,3);
kArrX = zeros(length(phi0),DESOL.len);
kArrY = zeros(length(phi0),DESOL.len);
kArrZ = zeros(length(phi0),DESOL.len);   

INPUT.stheta = stheta;
INPUT.sphi = sphi;
INPUT.p = p;
INPUT.rad = rad;
INPUT.deradsolfunc = deradsolinfunc;
INPUT.CLR = CLR;
defuncIn = @(t,y) CLR.ybcolourin(t,y,INPUT);
INPUT.deradsolfunc = deradsoloutfunc;
defuncOut = @(t,y) CLR.ybcolourout(t,y,INPUT);

%------------------------------------------
% Solve
%------------------------------------------
haderror = 0;
divs = 500;
for m = 1:ceil(length(phi0)/divs)
    if m*divs < length(phi0)
        narray = (m-1)*divs+1:m*divs;
    else
        narray = (m-1)*divs+1:length(phi0);
    end
    Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
    parfor n = narray 
        [x,Y] = ode113(defuncIn,tau1,[p,phi0(n),theta0(n)],options); 
        r1 = Y(:,1).';  
        phi1 = Y(:,2).'; 
        theta1 = Y(:,3).';
        if length(x) ~= length(tau1)
            error('AbsTol set to values that are too small');
        end
        if r1(length(r1)) < 0
            haderror(n) = 1;
        end
        [x,Y] = ode113(defuncOut,tau2,[p,phi0(n),theta0(n)],options);
        r = [0 flip(r1,2) Y(2:length(tau2),1).'];
        phi = [0 flip(phi1,2) Y(2:length(tau2),2).']; 
        theta = [0 flip(theta1,2) Y(2:length(tau2),3).'];
        kArrX(n,:) = r.*sin(phi).*cos(theta);                              
        kArrY(n,:) = r.*sin(phi).*sin(theta);
        kArrZ(n,:) = r.*cos(phi); 
    end
end

if sum(haderror) > 0
    err.flag = 1;
    err.msg = 'Negative DE Solution Problem. Adjust DE solution timing';
end

%------------------------------------------
% Consolidate
%------------------------------------------    
KSA(:,:,1) = kArrX;
KSA(:,:,2) = kArrY;
KSA(:,:,3) = kArrZ;

%------------------------------------------
% Calculate Real Timings
%------------------------------------------
tautot = (DESOL.plin)+[-(DESOL.plin) flip(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis 
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



