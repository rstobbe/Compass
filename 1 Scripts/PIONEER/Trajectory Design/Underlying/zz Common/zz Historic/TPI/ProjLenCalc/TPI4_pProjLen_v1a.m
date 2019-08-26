%====================================================
% 
%====================================================

function [PROJdgn] = TPI4_pProjLen_v1a(GAMFUNC,PROJdgn)

gamfunc = GAMFUNC.GamFunc;
tro = PROJdgn.tro;
p = PROJdgn.p;

if p == 1
    error('standard radial not accomodated');
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
projlen0 = interp1(rtot,tautest,PROJdgn.ovrshoot);

%-------------------------------
% finer solution
%-------------------------------
tau = (0:0.001:projlen0*1.05);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
tautest = [0 (x + p)'];
rtot = [0 abs(r)'];
ind = find(rtot == max(rtot));
rtot = rtot(1:ind);
tautest = tautest(1:ind);
totprojlen = interp1(rtot,tautest,PROJdgn.ovrshoot);
effprojlen = interp1(rtot,tautest,1);
efftro = tro*(effprojlen/totprojlen);
iseg = (efftro/effprojlen)*p;

PROJdgn.totprojlen = totprojlen;
PROJdgn.effprojlen = effprojlen;
PROJdgn.efftro = efftro;
PROJdgn.iseg = iseg;

Status2('done','',2);
Status2('done','',3);

