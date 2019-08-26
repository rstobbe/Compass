%=====================================================================
% (v1b)
%    
%=====================================================================

function [OUTPUT,err] = GenProj_TpiStandardTesting_v1b(INPUT)

Status2('done','Generate Standard TPI Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
RADEV = INPUT.RADEV;
TPIT = INPUT.TPIT;
DESOL = INPUT.DESOL;
PSMP = INPUT.PSMP;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
p = PROJdgn.p;
tro = PROJdgn.tro;

%---------------------------------------------
% Setup Differection Equation Solver
%---------------------------------------------
options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20]);
deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,p);
deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,p);

tau2 = DESOL.tau2;
phi0 = PSMP.phi;
theta0 = PSMP.theta;

%---------------------------------------------
% Setup
%---------------------------------------------
INPUT.TPIT = TPIT;
INPUT.deradsolfunc = deradsolinfunc;
INPUT.deradsolfunc = deradsoloutfunc;
defuncOut0 = @(t,y,phi) TPIT.tpiout(t,y,phi,INPUT); 

%---------------------------------------------
% Solve
%---------------------------------------------
haderror = 0;
divs = 200;
for m = 1:ceil(length(phi0)/divs)
    if m*divs < length(phi0)
        narray = (m-1)*divs+1:m*divs;
    else
        narray = (m-1)*divs+1:length(phi0);
    end
    if ceil(length(phi0)/divs) > 1
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(1))],2);
    else
        Status2('busy','Generate Trajectories',2);
    end
    for n = narray 
        %---------------------------------------------
        % Fix for phi == 0
        %---------------------------------------------
        if phi0(n) == 0                     
            phi = pi/2;                     % anything but zero
        else
            phi = phi0(n);                      
        end

        %---------------------------------------------
        % Outside
        %---------------------------------------------
        defuncOut = @(t,y) defuncOut0(t,y,phi);
        [x,Y] = ode113(defuncOut,tau2,[p,theta0(n)],options);
        r2 = Y(:,1).';
        theta2 = Y(:,2).';

        %---------------------------------------------
        % Join
        %---------------------------------------------
        inside = (0:0.001:r2(1)-0.001);
        r = real([inside r2]); 
        if phi0(n) == 0     
            theta = zeros(1,length(tau2)+length(inside));
            phi = phi0(n);
        else
            theta = real([zeros(1,length(inside)) theta2]);
        end
        
        %---------------------------------------------
        % Allocate
        %---------------------------------------------   
        if n == 1
            KSA = zeros(length(phi0),length(DESOL.tau2)+length(inside),3);
            kArrX = zeros(length(phi0),length(DESOL.tau2)+length(inside));
            kArrY = zeros(length(phi0),length(DESOL.tau2)+length(inside));
            kArrZ = zeros(length(phi0),length(DESOL.tau2)+length(inside));
        end

        %---------------------------------------------
        % Save
        %---------------------------------------------        
        kArrX(n,:) = r.*sin(phi).*cos(theta);                              
        kArrY(n,:) = r.*sin(phi).*sin(theta);
        kArrZ(n,:) = r.*cos(phi); 
    end
    if ceil(length(phi0)/divs) > 1
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
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
tautot = [inside PROJdgn.p+tau2(1:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis 
projlen0 = PROJdgn.p+DESOL.plout;
TArr = (tautot/projlen0)*tro;

%------------------------------------------
% Return
%------------------------------------------    
OUTPUT.projlen0 = projlen0;
OUTPUT.T = TArr;
OUTPUT.KSA = KSA;

figure(12341234); hold on;
plot(TArr,KSA(1,:,1));
plot(TArr,KSA(1,:,2));
plot(TArr,KSA(1,:,3));

Status2('done','',2);
Status2('done','',3);



