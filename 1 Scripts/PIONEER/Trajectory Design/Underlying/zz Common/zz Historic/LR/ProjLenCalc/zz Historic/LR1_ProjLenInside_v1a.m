%====================================================
% 
%====================================================

function [projlen] = LR1_ProjLenInside(p,RADEVFUN)

options = odeset('AbsTol',1e-6);

tau = (0:-0.01:-20);
[x,r] = ode45('Rad_Sol',tau,p,options,RADEVFUN);                        
ind = find(r < 0,1,'first');
ind = ind+1;
tau = (0:x(ind)/99999:x(ind));
[x,r] = ode45('Rad_Sol',tau,p,options,RADEVFUN);  
%projlen = abs(interp1(r,tau,0));
projlen = abs(x(find(r > 0,1,'last')));


