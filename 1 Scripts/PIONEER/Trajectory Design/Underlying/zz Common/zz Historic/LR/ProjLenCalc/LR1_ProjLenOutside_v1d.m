%====================================================
% (v1d)
%       - solve to a relative radius value greater than 1 (value R)
%====================================================

function [projlen,err] = LR1_ProjLenOutside_v1d(p,R,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = '';
err.flag = 0;
err.msg = '';

tau = (0:1:10000);
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc); 
ind = find(abs(r) > R,1,'first');
if isempty(ind)
    err.flag = 1;
    err.msg = 'Matrix Diameter and Number of Projections Impractical';
    return
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113('Rad_Sol',tau,p,options,deradsolfunc);  
projlen = interp1(abs(r),tau,R,'spline');

