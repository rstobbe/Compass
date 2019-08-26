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

% tau3 = -tau2;
% tau4 = tau1;
% len = length(tau1) + length(tau2) + length(tau3) + length(tau4) - 1;
len = length(tau1) + length(tau2);

KSA = zeros(length(phi0),len,3);
kArrX = zeros(length(phi0),len);
kArrY = zeros(length(phi0),len);
kArrZ = zeros(length(phi0),len);   

INPUT.stheta = stheta;
INPUT.sphi = sphi;
INPUT.p = p;
INPUT.rad = rad;
INPUT.deradsolfunc = deradsolinfunc;
INPUT.CLR = CLR;
defuncIn = @(t,y) CLR.ybcolourin(t,y,INPUT);
%defuncInReturn = @(t,y) CLR.ybcolourinreturn(t,y,INPUT);
INPUT.deradsolfunc = deradsoloutfunc;
defuncOut = @(t,y) CLR.ybcolourout(t,y,INPUT);
%defuncOutReturn = @(t,y) CLR.ybcolouroutreturn(t,y,INPUT);

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
    for n = narray 
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
        r2 = Y(2:length(tau2),1).';
        phi2 = Y(2:length(tau2),2).'; 
        theta2 = Y(2:length(tau2),3).';
        Kend(1) = r2(end).*sin(phi2(end)).*cos(theta2(end));                              
        Kend(2) = r2(end).*sin(phi2(end)).*sin(theta2(end));
        Kend(3) = r2(end).*cos(phi2(end));   
        
%         [x,Y] = ode113(defuncOutReturn,tau3,[r2(end),phi2(end),theta2(end)],options);        
%         r3 = Y(2:length(tau3),1).';
%         phi3 = Y(2:length(tau3),2).'; 
%         theta3 = Y(2:length(tau3),3).';
% 
%         [x,Y] = ode113(defuncInReturn,tau4,[r3(end),phi3(end),theta3(end)],options);        
%         r4 = [Y(2:length(tau4),1).' 0];
%         phi4 = [Y(2:length(tau4),2).' 0]; 
%         theta4 = [Y(2:length(tau4),3).' 0];
%         
        r = [0 flip(r1,2) r2];
        phi = [0 flip(phi1,2) phi2]; 
        theta = [0 flip(theta1,2) theta2];
        kArrX(n,:) = r.*sin(phi).*cos(theta);                              
        kArrY(n,:) = r.*sin(phi).*sin(theta);
        kArrZ(n,:) = r.*cos(phi);  
% 
%         kArrXt = r3.*sin(phi3).*cos(theta3);                              
%         kArrYt = r3.*sin(phi3).*sin(theta3);
%         kArrZt = r3.*cos(phi3); 
% 
%         kArrXt2 = r4.*sin(phi4).*cos(theta4);                              
%         kArrYt2 = r4.*sin(phi4).*sin(theta4);
%         kArrZt2 = r4.*cos(phi4);         
        
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

figure(123450); hold on; axis equal; grid on; 
plot3(KSA(1,:,1),KSA(1,:,2),KSA(1,:,3),'k','linewidth',1);
%plot3(kArrXt,kArrYt,kArrZt,'r','linewidth',1);
%plot3(kArrXt2,kArrYt2,kArrZt2,'b','linewidth',1);
xlim([-1,1]); ylim([-1,1]); zlim([-1,1]);

Q = [0,Kend(1),Kend(2),Kend(3)];                % 180 rotation Quaternion
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



