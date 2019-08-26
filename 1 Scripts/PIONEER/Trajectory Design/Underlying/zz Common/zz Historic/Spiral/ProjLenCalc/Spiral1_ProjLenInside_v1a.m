%====================================================
% 
%====================================================

function [projlen,err] = Spiral1_ProjLenInside_v1a(p,deradsolfunc,RADEV)

tol = RADEV.intol;
plout = RADEV.plout;

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = '';
err.flag = 0;
err.msg = '';

top = RADEV.solinlenfact*(1/plout)/3;
tau = (0:-0.00001:-top);
%[x,r] = ode113('Rad2D_Sol',tau,p,options,deradsolfunc);   
[x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);   
ind = find(r < 0,1,'first');

if length(x)<length(tau)
    figure(10000);
    title('InTol too High');
    plot(x,r); xlabel('tau'); ylabel('relative radius');
    error();                    % AbsTol set to values that are too small
end
if isempty(ind)
    figure(10000);
    title('Did not Solve to Zero');
    plot(x,r); xlabel('tau'); ylabel('relative radius');
    err.flag = 1;
    err.msg = 'Increase Inside Solution Length';
    return
end
show = 1;
if show == 1
    figure(10000); hold on;
    plot(x,r); xlabel('tau'); ylabel('relative radius');
    title('Timing of Inside Radius Solution');
    plot([x(ind) x(ind)],[min(r) max(r)],'k:');
    plot([min(x) max(x)],[0 0],'k');
end

ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode45('Rad2D_Sol',tau,p,options,deradsolfunc);  
%projlen = abs(interp1(r,tau,0));
projlen = abs(x(find(r > 0,1,'last')));


