%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRandKshRCOS_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
stdevthetafos = str2double(SCRPTipt(strcmp('StdevTheta(fracOS)',{SCRPTipt.labelstr})).entrystr);
stdevphi = str2double(SCRPTipt(strcmp('StdevPhi(deg)',{SCRPTipt.labelstr})).entrystr);

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

thnprojfull = round((4*pi*(rad)^2));

elip = 1;
PROJimp.nproj = PROJdgn.nproj;
projosamp = (PROJimp.nproj)/projdist.thnproj;

stdevtheta = stdevthetafos*projosamp;

oscnt = 0;
n = 1;
m = -thnprojfull/2;
P1 = sqrt(elip*2*PROJimp.nproj*pi);
while m <= thnprojfull/2;    
    Pz = (2*m)/(2*thnprojfull/2); 
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
    randincphi = stdevphi*pi/180*randn(1);
    phi(n) = phi(n) + randincphi;
    fullinc = 1/p;
    usinc = fullinc/projosamp;
    randind = stdevtheta*randn(1)*fullinc;
    if (usinc + randind) < fullinc
        oscnt = oscnt + 1
    end
    m = m + usinc + randind;
    n = n+1;
end

%projdist.RCOS = RCOS;
%totalprojs = round(projdist.thnproj*RCOS);
%PROJimp.nprojrc = totalprojs - PROJdgn.nproj;

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

