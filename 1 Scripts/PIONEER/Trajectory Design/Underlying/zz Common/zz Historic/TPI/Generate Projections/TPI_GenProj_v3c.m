%==================================================
% (v3b)
%       - fix for updated Gamfunc calling
%==================================================

function [T,KSA,err] = TPI_GenProj_v3c(PROJdgn,GAMFUNC,ImpStrct)

%---------------------------------------------
% Unload Variables
%---------------------------------------------
p = PROJdgn.p;
elip = PROJdgn.elip;
projlen = PROJdgn.projlen;
IV = ImpStrct.IV;
slvno = ImpStrct.slvno;

%---------------------------------------------
% Get Gamma Functions
%---------------------------------------------
func = str2func([PROJdgn.gamfunc,'_Func']);
INPUT = struct();
[GAMFUNC,err] = func(GAMFUNC,INPUT);
if err.flag ~= 0
    return
end
clear INPUT
gamfunc = GAMFUNC.GamFunc;
G = @(r) gamfunc(r,p);

%---------------------------------------------
% Generate Trajectories
%---------------------------------------------
set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-6);

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
    Status('busy',strcat('Building Projection:_',num2str(n)));
end



