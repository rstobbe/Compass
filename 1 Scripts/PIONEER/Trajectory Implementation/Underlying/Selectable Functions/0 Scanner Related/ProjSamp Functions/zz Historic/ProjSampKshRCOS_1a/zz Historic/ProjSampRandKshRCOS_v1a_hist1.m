%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRandKshRCOS_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
RCOS = str2double(SCRPTipt(strcmp('RCOS',{SCRPTipt.labelstr})).entrystr);
stdev = 1;

projdist.sym = 1;
rad = PROJdgn.rad;
p = PROJdgn.p;
projdist.thnproj = round((4*pi*(rad)^2)*p);
projdist.RCOS = RCOS;
totalprojs = round(projdist.thnproj*RCOS);
PROJimp.nprojrc = totalprojs - PROJdgn.nproj;

if SCRPTGBL.testing == 1
    PROJimp.nproj = PROJimp.tnproj;
    projdist.IV(1,:) = linspace(0,pi/2,PROJimp.nproj);
    projdist.IV(2,:) = zeros(1,PROJimp.nproj);
    PROJimp.projdist = projdist;
    return
end

elip = 1;
PROJimp.nproj = PROJdgn.nproj;
projosamp = (PROJimp.nproj-1)/projdist.thnproj;
P1 = sqrt(elip*2*PROJimp.nproj*pi);

n = 1;
m = -projdist.thnproj/2;
while m <= projdist.thnproj/2;    
    Pz = (2*m)/(2*projdist.thnproj/2); 
    Px = cos(P1*asin(Pz))*sqrt(1-Pz^2);
    Py = sin(P1*asin(Pz))*sqrt(1-Pz^2);

    Pr = sqrt(Pz^2 + Py^2 + Px^2);
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
    m = m + 1/projosamp + stdev*randn(1);
    n = n+1;
end

projdist.IV(1,:) = phi; 
projdist.IV(2,:) = theta;

PROJimp.projdist = projdist;
PROJimp.nproj = length(phi);

%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nprojrc','0output',PROJimp.nprojrc,'0numout');


figure(53)
hold on
axis equal;
grid on;
%phi = projdist.IV(1,PROJimp.impprojs);
%theta = projdist.IV(2,PROJimp.impprojs);
for i = 1:PROJimp.nproj  
    if cos(phi(i)) < 0
    	plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'b*');
    else
        plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'r*');
    end
    %pause(0.001);
end
figure(54)
hold on
axis equal;
grid on;
for i = 1:PROJimp.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end

return
error('not finished')

figure(51)
hold on
axis equal;
grid on;
phi = projdist.IV(1,:);
theta = projdist.IV(2,:);
for i = 1:totalprojs 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'*');
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:totalprojs
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end

