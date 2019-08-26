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
IMPTYPE = INPUT.IMPTYPE;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Get Stuff
%---------------------------------------------
defuncIn = IMPTYPE.ybcolourin;
defuncOut = IMPTYPE.ybcolourout;
tau1 = IMPTYPE.tau1;
tau2 = IMPTYPE.tau2;
rad0 = IMPTYPE.rad0;
phi0 = IMPTYPE.phi0;
theta0 = IMPTYPE.theta0;

%------------------------------------------
% Initialize
%------------------------------------------
options = odeset('RelTol',2.5e-14,'AbsTol',[1e-20,1e-20,1e-20]);
divs = 500;

%=====================================================================
% Solve Normal
%=====================================================================
if IMPTYPE.dir == 1 
    KSA = zeros(length(phi0),IMPTYPE.len,3);
    kArrX = zeros(length(phi0),IMPTYPE.len);
    kArrY = zeros(length(phi0),IMPTYPE.len);
    kArrZ = zeros(length(phi0),IMPTYPE.len);  
    EndVals = zeros(length(phi0),3);
    for m = 1:ceil(length(phi0)/divs)
        if m*divs < length(phi0)
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:length(phi0);
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        parfor n = narray 
            [x,Y] = ode113(defuncIn,tau1,[rad0,phi0(n),theta0(n)],options); 
            rad1 = Y(:,1).';  
            phi1 = Y(:,2).'; 
            theta1 = Y(:,3).';
            [x,Y] = ode113(defuncOut,tau2,[rad0,phi0(n),theta0(n)],options);
            EndVals(n,:) = Y(end,:);
            rad = [0 flip(rad1,2) Y(2:end,1).'];
            phi = [0 flip(phi1,2) Y(2:end,2).']; 
            theta = [0 flip(theta1,2) Y(2:end,3).'];
            kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
            kArrY(n,:) = rad.*sin(phi).*sin(theta);
            kArrZ(n,:) = rad.*cos(phi); 
        end
    end
    
%=====================================================================
% Solve Return to Centre
%=====================================================================
elseif IMPTYPE.dir == -1
    KSA = zeros(length(phi0),IMPTYPE.len-1,3);
    kArrX = zeros(length(phi0),IMPTYPE.len-1);
    kArrY = zeros(length(phi0),IMPTYPE.len-1);
    kArrZ = zeros(length(phi0),IMPTYPE.len-1);  
    EndVals = zeros(length(phi0),3);
    for m = 1:ceil(length(phi0)/divs)
        if m*divs < length(phi0)
            narray = (m-1)*divs+1:m*divs;
        else
            narray = (m-1)*divs+1:length(phi0);
        end
        Status2('busy',['Generate Trajectory Number: ',num2str(narray(end))],2);
        parfor n = narray 
            [x,Y] = ode113(defuncOut,tau2,[rad0(n),phi0(n),theta0(n)],options);
            rad1 = Y(:,1).';  
            phi1 = Y(:,2).'; 
            theta1 = Y(:,3).';
            [x,Y] = ode113(defuncIn,tau1,[rad1(end),phi1(end),theta1(end)],options); 
            rad = [rad1(2:end) Y(2:end,1).' 0];
            phi = [phi1(2:end) Y(2:end,2).' 0]; 
            theta = [theta1(2:end) Y(2:end,3).' 0];
            kArrX(n,:) = rad.*sin(phi).*cos(theta);                              
            kArrY(n,:) = rad.*sin(phi).*sin(theta);
            kArrZ(n,:) = rad.*cos(phi); 
        end
    end
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
OUTPUT.EndVals = EndVals;

Status2('done','',2);
Status2('done','',3);



