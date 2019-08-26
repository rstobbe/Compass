%==================================================
% last point from (TPI_GenProj_v2a)
%==================================================

function [KSA] = TPI_GenProjLastPoint_v2a(PROJdgn,ImpStrct)

p = PROJdgn.p;
elip = PROJdgn.elip;
gamfunc = PROJdgn.GamFunc;
projlen = PROJdgn.projlen;
IV = ImpStrct.IV;

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-6);

G = @(r) gamfunc(r,p);

phi0 = IV(1,:);
theta0 = IV(2,:);
nproj = length(phi0);

tau = projlen-p;
KSA = zeros(nproj,3);

for n = 1:nproj
    if phi0(n) == 0
        %[x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));      % for some reason phi = zero solves to a shorter value...
        %r = [0 real(Y(:,1))'];
        %theta = zeros(1,slvno);
        [x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,pi);
        r = -[0 real(Y(:,1))'];
        theta = zeros(1,slvno);
    else
        [x,Y] = ode45('CPA_Sol',tau,[p,theta0(n)],options,G,phi0(n));
        r = [0 real(Y(:,1))'];
        theta = [0 real(Y(:,2))'];
    end
    KSA(n,1) = r.*cos(theta).*sin(phi0(n));                              % design location of each point in k-space
    KSA(n,2) = r.*sin(theta).*sin(phi0(n));
    KSA(n,3) = r.*cos(phi0(n))*elip;
           
    Status('busy',strcat('Building Projection:_',num2str(n)));
end



