%====================================================
% (v1d)
%       - no change from (v1c)
%       - version change to match 'Outside'
%====================================================

function [projlen,err] = LR1_ProjLenInside_v1d(p,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
err.flag = 0;
err.msg = '';

tau = (0:-0.01:-200);
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc);  
ind = find(r < 0,1,'first');
if isempty(ind)
    error('tolerance set too high - fix');
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc);  
%projlen = abs(x(find(r > 0,1,'last')));
projlen = abs(interp1(r,tau,0,'spline'));