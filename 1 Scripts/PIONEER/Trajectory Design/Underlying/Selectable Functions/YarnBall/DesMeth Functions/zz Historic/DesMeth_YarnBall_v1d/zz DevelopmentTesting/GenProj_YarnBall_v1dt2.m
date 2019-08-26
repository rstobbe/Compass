%=====================================================================
% (v1dt)
%      - testing
%=====================================================================

function [OUTPUT,err] = GenProj_YarnBall_v1dt(INPUT)

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

phi0 = PSMP.phi;
theta0 = PSMP.theta;

tau1 = DESOL.tau1;
tau2 = DESOL.tau2;

tau3 = -tau2;
tau4 = tau1;
len1 = length(tau1) + length(tau2);
len2 = length(tau3) + length(tau4) - 2;

KSA1 = zeros(length(phi0),len1,3);

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
divs = 500;
for m = 1:ceil(length(phi0)/divs)
    if m*divs < length(phi0)
        narray = (m-1)*divs+1:m*divs;
    else
        narray = (m-1)*divs+1:length(phi0);
    end
    Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
    for n = narray 
        [x,Y] = ode113(defuncIn,tau1,[p,phi0(n),theta0(n)],options); 
        r1 = Y(:,1).';  
        phi1 = Y(:,2).'; 
        theta1 = Y(:,3).';
        
        [x,Y] = ode113(defuncOut,tau2,[p,phi0(n),theta0(n)],options);
        r2 = Y(2:length(tau2),1).';
        phi2 = Y(2:length(tau2),2).'; 
        theta2 = Y(2:length(tau2),3).';
        
        r = [0 flip(r1,2) r2];
        phi = [0 flip(phi1,2) phi2]; 
        theta = [0 flip(theta1,2) theta2];
        KSA1(n,:,1) = r.*sin(phi).*cos(theta);                              
        KSA1(n,:,2) = r.*sin(phi).*sin(theta);
        KSA1(n,:,3) = r.*cos(phi);     
    end
end

defuncTransition = @(t,y) CLR.ybcolourtransition(t,y,INPUT);
dy = defuncTransition(0,1.18);  

[x,Y] = ode113(defuncTransition,(0:0.1:2),[r2(end),phi2(end),theta2(end)],options); 
r3 = Y(2:end,1).';
phi3 = Y(2:end,2).'; 
theta3 = Y(2:end,3).';

KSA2 = zeros(1,length(0:0.1:2)-1,3);
KSA2(n,:,1) = r3.*sin(phi3).*cos(theta3);                              
KSA2(n,:,2) = r3.*sin(phi3).*sin(theta3);
KSA2(n,:,3) = r3.*cos(phi3);        

KSA = cat(2,KSA1,KSA2);

figure(123450); hold on; axis equal; grid on; 
plot3(KSA(1,:,1),KSA(1,:,2),KSA(1,:,3),'k','linewidth',1);
%plot3(kArrXt,kArrYt,kArrZt,'r','linewidth',1);
xlim([-1.3,1.3]); ylim([-1.3,1.3]); zlim([-1.3,1.3]);


Q = [0,KSA(1,end,1),KSA(1,end,2),KSA(1,end,3)];                % 180 rotation Quaternion
%Q = [1,0,0,0];
Q = Q/norm(Q);

% http://www.astro.rug.nl/software/kapteyn/_downloads/attitude.pdf
Qmat = [Q(1)^2+Q(2)^2-Q(3)^2-Q(4)^2     2*(Q(2)*Q(3)+Q(1)*Q(4))         2*(Q(2)*Q(4)-Q(1)*Q(3)); ...
        2*(Q(2)*Q(3)-Q(1)*Q(4))         Q(1)^2-Q(2)^2+Q(3)^2-Q(4)^2     2*(Q(3)*Q(4)+Q(1)*Q(2)); ...
        2*(Q(2)*Q(4)+Q(1)*Q(3))         2*(Q(3)*Q(4)-Q(1)*Q(2))         Q(1)^2-Q(2)^2-Q(3)^2+Q(4)^2];

tKSA = squeeze(KSA);
rKSA = tKSA*Qmat;    
    
plot3(rKSA(:,1),rKSA(:,2),rKSA(:,3),'b','linewidth',1);

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



