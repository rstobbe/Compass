%====================================================
% 
%====================================================

function [projlen,iseg] = TPI1_pProjLen_v1a(gamfunc,Tro,p)

if p == 1
    projlen = 1;
    iseg = Tro;
    return
end

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4);

G = @(r) gamfunc(r,p);
%-------------------------------
% initial test
%-------------------------------
tau = (0:0.005:20);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
tautest = [0 (x + p)'];
rtot = [0 abs(r)'];
ind = find(rtot == max(rtot));
rtot = rtot(1:ind);
tautest = tautest(1:ind);
projlen = interp1(rtot,tautest,1);
%iseginit = (Tro/projlen)*p;

%-------------------------------
% finer solution
%-------------------------------
tau = (0:0.001:projlen*1.05);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
tautest = [0 (x + p)'];
rtot = [0 abs(r)'];
ind = find(rtot == max(rtot));
rtot = rtot(1:ind);
tautest = tautest(1:ind);
projlen = interp1(rtot,tautest,1);
iseg = (Tro/projlen)*p;

Status2('done','',2);
Status2('done','',3);

