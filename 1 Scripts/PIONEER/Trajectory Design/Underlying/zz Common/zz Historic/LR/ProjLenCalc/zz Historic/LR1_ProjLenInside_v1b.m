%====================================================
% 
%====================================================

function [projlen,err] = LR1_ProjLenInside_v1b(p,deradsolfunc)

%options = odeset('AbsTol',1e-6);
options = odeset('RelTol',1e-11,'AbsTol',1e-11);
err.flag = 0;
err.msg = '';

tau = (0:-0.01:-100);
[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);                        
ind = find(r < 0,1,'first');
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);  
%projlen = abs(interp1(r,tau,0));
projlen = abs(x(find(r > 0,1,'last')));


