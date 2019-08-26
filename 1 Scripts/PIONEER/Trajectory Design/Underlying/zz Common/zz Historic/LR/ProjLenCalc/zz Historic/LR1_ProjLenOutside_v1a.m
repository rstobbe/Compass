%====================================================
% 
%====================================================

function [projlen,error,errorflag] = LR1_ProjLenOutside(p,RADEVFUN)

options = odeset('AbsTol',1e-6);
projlen = '';
error = '';
errorflag = 0;

tau = (0:1:10000);
[x,r] = ode45('Rad_Sol',tau,p,options,RADEVFUN);                        
ind = find(abs(r) > 1,1,'first');
if isempty(ind)
    errorflag = 1;
    error = 'Matrix Diameter and Number of Projections Impractical';
    return
end
ind = ind+1;
tau = (0:x(ind)/9999:x(ind));
[x,r] = ode45('Rad_Sol',tau,p,options,RADEVFUN);  
projlen = interp1(abs(r),tau,1);


