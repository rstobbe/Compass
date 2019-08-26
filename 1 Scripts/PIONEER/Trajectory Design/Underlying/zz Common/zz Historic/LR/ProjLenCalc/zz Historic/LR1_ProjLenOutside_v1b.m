%====================================================
% 
%====================================================

function [projlen,err] = LR1_ProjLenOutside_v1b(p,deradsolfunc)

options = odeset('AbsTol',1e-6);
%options = odeset('RelTol',1e-12,'AbsTol',1e-12);
projlen = '';
err.flag = 0;
err.msg = '';

tau = (0:1:10000);
[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);                        
ind = find(abs(r) > 1,1,'first');
if isempty(ind)
    err.flag = 1;
    err.msg = 'Matrix Diameter and Number of Projections Impractical';
    return
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode45('Rad_Sol',tau,p,options,deradsolfunc);  
projlen = interp1(abs(r),tau,1,'spline');

test = 0;

