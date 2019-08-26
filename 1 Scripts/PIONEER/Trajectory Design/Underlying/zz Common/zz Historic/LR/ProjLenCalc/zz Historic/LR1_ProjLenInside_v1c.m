%====================================================
% 
%====================================================

function [projlen,err] = LR1_ProjLenInside_v1c(p,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
err.flag = 0;
err.msg = '';

tau = (0:-0.01:-200);
%[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc);  
ind = find(r < 0,1,'first');
if isempty(ind)
    r
    error('tolerance set too high - fix');
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
%[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc);  
%projlen = abs(interp1(r,tau,0));
projlen = abs(x(find(r > 0,1,'last')));
