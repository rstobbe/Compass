%=====================================================================
% (v1b)
%    
%=====================================================================

function [OUTPUT,err] = GenProj_TpiCaTesting1_v1b(INPUT)

Status2('done','Generate TPI Trajectory',2);
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
%options = odeset('RelTol',2.5e-14,'AbsTol',[1e-25,1e-25]);
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

%---------------------------------------------
% Setup
%---------------------------------------------
INPUT.TPIT = TPIT;
INPUT.deradsolfunc = deradsolinfunc;
defuncIn0 = @(t,y,phi) TPIT.tpiin(t,y,phi,INPUT); 
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
    parfor n = narray 
        %---------------------------------------------
        % Fix for phi == 0
        %---------------------------------------------
        if phi0(n) == 0                     
            phi = pi/2;                     % anything but zero
        else
            phi = phi0(n);                      
        end
        
        %---------------------------------------------
        % Inside
        %---------------------------------------------
        defuncIn = @(t,y) defuncIn0(t,y,phi);
        [x,Y] = ode113(defuncIn,tau1,[p,theta0(n)],options); 
        r1 = Y(:,1).';  
        theta1 = Y(:,2).';

        %---------------------------------------------
        % Outside
        %---------------------------------------------
        defuncOut = @(t,y) defuncOut0(t,y,phi);
        [x,Y] = ode113(defuncOut,tau2,[p,theta0(n)],options);
        r2 = Y(2:length(tau2),1).';
        theta2 = Y(2:length(tau2),2).';

        %---------------------------------------------
        % Join
        %---------------------------------------------
        r = real([0 flip(r1,2) r2]); 
        if phi0(n) == 0     
            theta = zeros(1,length(tau1)+length(tau2));
            phi = phi0(n);
        else
            theta = real([0 flip(theta1,2) theta2]);
        end
        
        %---------------------------------------------
        % Save
        %---------------------------------------------        
        kArrX(n,:) = r.*sin(phi).*cos(theta);                              
        kArrY(n,:) = r.*sin(phi).*sin(theta);
        kArrZ(n,:) = r.*cos(phi); 
        %kArrZ(n,:) = r.*cos(phi)*elip;                     % not here
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



