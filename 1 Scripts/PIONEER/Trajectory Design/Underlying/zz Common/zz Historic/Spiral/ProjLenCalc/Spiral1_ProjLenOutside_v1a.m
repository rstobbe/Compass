%====================================================
% 
%====================================================

function [projlen,err] = Spiral1_ProjLenOutside_v1a(p,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = '';
err.flag = 0;
err.msg = '';

tau = (0:0.1:50);
[x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);                        
ind = find(abs(r) > 1,1,'first');
if isempty(ind)
    tau = (49:0.1:200);
    [x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);                        
    ind = find(abs(r) > 1,1,'first');
    if isempty(ind)
        tau = (199:0.1:500);
        [x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);                        
        ind = find(abs(r) > 1,1,'first');
        if isempty(ind)
            tau = (499:0.1:2000);
            [x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);                        
            ind = find(abs(r) > 1,1,'first');
            if isempty(ind)
                figure(10000);
                plot(x,r)
                error();
            end
        end
    end
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);  
projlen = interp1(abs(r),tau,1,'spline');

