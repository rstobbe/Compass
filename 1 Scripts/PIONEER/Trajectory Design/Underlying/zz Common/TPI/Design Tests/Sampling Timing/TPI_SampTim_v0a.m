%====================================================
% 
%====================================================

function [tatr] = TPI_SampTim_v0a(pdr,p,Tro,gamfunc,projlen)

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4);                                   

G = @(r) gamfunc(r,p);

tau = (0:0.001:projlen*1.01);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
rtemp = [0 abs(r)'];
tautemp = [0 (x + p)'];

tatr = (Tro/projlen)*interp1(rtemp,tautemp,pdr);


