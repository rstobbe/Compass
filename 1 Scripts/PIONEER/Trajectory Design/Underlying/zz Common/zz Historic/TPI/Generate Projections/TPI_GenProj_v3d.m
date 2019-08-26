%==================================================
% (v3d)
%       - Input/Output Update
%==================================================

function [OUTPUT,err] = TPI_GenProj_v3d(DES,INPUT)

Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = DES.PROJdgn;
GAMFUNC = DES.GAMFUNC;
PSMP = INPUT.PSMP;
slvno = INPUT.slvno;
clear INPUT;
OUTPUT = struct();

%---------------------------------------------
% Unload Variables
%---------------------------------------------
p = PROJdgn.p;
elip = PROJdgn.elip;
projlen = PROJdgn.projlen;
IV = PSMP.IV;

%---------------------------------------------
% Get Gamma Functions
%---------------------------------------------
func = str2func([DES.gamfunc,'_Func']);
INPUT = struct();
[GAMFUNC,err] = func(GAMFUNC,INPUT);
if err.flag ~= 0
    return
end
clear INPUT
gamfunc = GAMFUNC.GamFunc;
G = @(r) gamfunc(r,p);

%===================================================
% Generate Trajectories
%===================================================
options = odeset('RelTol',1e-7,'AbsTol',[1e-7,1e-7]);

phi0 = IV(1,:);
theta0 = IV(2,:);
nproj = length(phi0);
slvint = (projlen-p)/(slvno-2);
tau = (0:slvint:(projlen-p));
if p == 1
    KSA = zeros(nproj,2,3);
    T = [0 1];
else
    KSA = zeros(nproj,slvno,3);
    T = [0 p+tau]; 
end

for n = 1:nproj
    Status2('busy',['Generate Trajectory Number: ',num2str(n)],2);
    if p == 1
        r = [0 1];
        theta = [0 theta0(n)];
    else
        if phi0(n) == 0
            %[x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));      % for some reason phi = zero solves to a shorter value...
            %r = [0 real(Y(:,1))'];
            %theta = zeros(1,slvno);
            [x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,pi);
            r = [0 real(Y(:,1))'];
            theta = zeros(1,slvno);
        else
            [x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));
            r = [0 real(Y(:,1))'];
            theta = [0 real(Y(:,2))'];
        end
    end
    test = r(length(r));
    if round(test*1.0e3) ~= 1.0e3
        err = round(test*1.0e3)
        error();
    end
    KSA(n,:,1) = r.*cos(theta).*sin(phi0(n));                              % design location of each point in k-space
    KSA(n,:,2) = r.*sin(theta).*sin(phi0(n));
    KSA(n,:,3) = r.*cos(phi0(n))*elip;         
end

%------------------------------------------
% Return
%------------------------------------------    
OUTPUT.T = T;
OUTPUT.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);

