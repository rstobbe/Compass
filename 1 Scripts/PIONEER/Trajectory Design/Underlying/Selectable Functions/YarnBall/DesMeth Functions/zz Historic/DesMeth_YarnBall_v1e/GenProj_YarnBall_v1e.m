%=====================================================================
% (v1e)
%      - changes...
%=====================================================================

function [OUTPUT,err] = GenProj_YarnBall_v1e(INPUT)

Status2('done','Generate YarnBall Trajectory',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
DESOL = INPUT.DESOL;
PSMP = INPUT.PSMP;
IMPTYPE = INPUT.IMPTYPE;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Get Stuff
%---------------------------------------------
p = PROJdgn.p;
defuncIn = IMPTYPE.ybcolourin;
defuncOut = IMPTYPE.ybcolourout;

%------------------------------------------
% Solve
%------------------------------------------
tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
phi0 = PSMP.phi;
theta0 = PSMP.theta;
KSA = zeros(length(phi0),DESOL.len,3);
kArrX = zeros(length(phi0),DESOL.len);
kArrY = zeros(length(phi0),DESOL.len);
kArrZ = zeros(length(phi0),DESOL.len);  

haderror = 0;
divs = 500;
options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
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
% Return
%------------------------------------------    
OUTPUT.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);



