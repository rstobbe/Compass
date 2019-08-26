%====================================================
% 
%====================================================

function [GAM] = TPI_SampTim_v1a(GAM,PROJdgn)

pdr = GAM.r;
p = GAM.p;
Tro = PROJdgn.tro;
gamfunc = GAM.GamFunc;
projlen = GAM.projlen0;

set(0,'RecursionLimit',500);
options = odeset('RelTol',1e-4);                                   

G = @(r) gamfunc(r,p);

tau = (0:0.001:projlen*1.01);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
if isempty(r(r > 1))
    error;                                      % increase test projlen (above)
end
r = r(r < 1);
x = x(r < 1);
rtemp = [0 abs(r)'];
tautemp = [0 (x + p)'];

GAM.projlen = tautemp(end);
GAM = rmfield(GAM,'projlen0');

GAM.tatr = (Tro/GAM.projlen)*interp1(rtemp,tautemp,pdr,'pchip','extrap');



