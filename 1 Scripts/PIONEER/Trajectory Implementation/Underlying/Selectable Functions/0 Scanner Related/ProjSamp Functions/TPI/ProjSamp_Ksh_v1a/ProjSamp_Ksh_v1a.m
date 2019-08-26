%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampKsh_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;

projdist.sym = 1;
rad = PROJdgn.rad;
p = PROJdgn.p;
projdist.thnproj = round((4*pi*(rad)^2)*p);

if SCRPTGBL.testing == 1
    PROJimp.nproj = PROJimp.tnproj;
    projdist.IV(1,:) = linspace(0,pi/2,PROJimp.nproj);
    projdist.IV(2,:) = zeros(1,PROJimp.nproj);
    PROJimp.projdist = projdist;
    return
end

PROJimp.nproj = PROJdgn.nproj;
projosamp = (PROJimp.nproj-1)/projdist.thnproj;
P1 = sqrt(2*PROJimp.nproj*pi);

n = 1;
m = -projdist.thnproj/2;
while round(m*1e9)/1e9 <= projdist.thnproj/2;     
    Pz = (2*m)/(2*projdist.thnproj/2); 
    Px = cos(P1*asin(Pz))*sqrt(1-Pz^2);
    Py = sin(P1*asin(Pz))*sqrt(1-Pz^2);

    %Pr = sqrt(Pz^2 + Py^2 + Px^2);
    Pr = 1;
    phi(n) = acos(Pz/Pr);    
    theta0 = atan(Py/Px);
    if isnan(theta0)
        theta(n) = 0;
    else
        if sign(Px) < 0
            theta(n) = pi + theta0;
        else 
            theta(n) = theta0;
        end
    end
    m = m + 1/projosamp;
    n = n+1;
end

projdist.IV(1,:) = phi; 
projdist.IV(2,:) = theta;

PROJimp.projdist = projdist;

figure(51)
hold on
axis equal;
grid on;
for i = 1:PROJimp.nproj  
    if cos(phi(i)) < 0
    	plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'b*');
    else
        plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'r*');
    end
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:PROJimp.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end

%error('break');
