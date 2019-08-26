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

%thnprojfull = round((4*pi*(rad)^2));

elip = 1;
PROJimp.nproj = PROJdgn.nproj;
projosamp = (PROJimp.nproj)/projdist.thnproj;

stdevtheta = stdevthetafos*projosamp;

oscnt = 0;
impcnt = 1;
rcaddcnt = 1;
m = -projdist.thnproj/2;
P1 = sqrt(elip*2*PROJimp.nproj*pi);
while m <= projdist.thnproj/2;    
    Pz = (2*m)/(2*projdist.thnproj/2); 
    Px = cos(P1*asin(Pz))*sqrt(1-Pz^2);
    Py = sin(P1*asin(Pz))*sqrt(1-Pz^2);
    Pr = sqrt(Pz^2 + Py^2 + Px^2);
    impphi(impcnt) = acos(Pz/Pr);    
    theta0 = atan(Py/Px);
    if isnan(theta0)
        imptheta(impcnt) = 0;
    else
        if sign(Px) < 0
            imptheta(impcnt) = pi + theta0;
        else 
            imptheta(impcnt) = theta0;
        end
    end
    randvarphi = stdevphi*pi/180*randn(1);
    impphi(impcnt) = impphi(impcnt) + randvarphi;
    %fullinc = 1/p;
    fullinc = 1;
    usinc = fullinc/projosamp;
    randinc = stdevtheta*randn(1)*fullinc;
    totrelinc = (usinc + randinc)/fullinc;
    if totrelinc < 1
        oscnt = oscnt + 1
    elseif totrelinc < 2
        addm = m + fullinc*totrelinc/2;
    elseif totrelinc < 3
        addm(1) = m + fullinc*totrelinc/3;    
        addm(2) = m + 2*fullinc*totrelinc/3;
    elseif totrelinc < 4
        addm(1) = m + fullinc*totrelinc/4;    
        addm(2) = m + 2*fullinc*totrelinc/4;    
        addm(3) = m + 3*fullinc*totrelinc/4;
    else
        error();
    end
    for a = 1:length(addm)
        if addm(a) > projdist.thnproj/2
            break
        end
        Pz = (2*addm(a))/(2*projdist.thnproj/2); 
        Px = cos(P1*asin(Pz))*sqrt(1-Pz^2);
        Py = sin(P1*asin(Pz))*sqrt(1-Pz^2);
        Pr = sqrt(Pz^2 + Py^2 + Px^2);
        rcaddphi(rcaddcnt) = acos(Pz/Pr);    
        theta0 = atan(Py/Px);
        if isnan(theta0)
            rcaddtheta(rcaddcnt) = 0;
        else
            if sign(Px) < 0
                rcaddtheta(rcaddcnt) = pi + theta0;
            else 
                rcaddtheta(rcaddcnt) = theta0;
            end
        end
        rcaddcnt = rcaddcnt + 1;
    end
    
    m = m + usinc + randinc;
    impcnt = impcnt+1;
end

PROJimp.nproj = length(impphi);
PROJimp.impprojs = (1:PROJimp.nproj);
PROJimp.nprojrc = length(rcaddphi);
projdist.RCOS = (length(impphi)+length(rcaddphi))/projdist.thnproj;
projdist.IV(1,:) = [impphi rcaddphi]; 
projdist.IV(2,:) = [imptheta rcaddtheta];
PROJimp.projdist = projdist;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nprojrc','0output',PROJimp.nprojrc,'0numout');

figure(51)
hold on
axis equal;
grid on;
phi = projdist.IV(1,PROJimp.impprojs);
theta = projdist.IV(2,PROJimp.impprojs);
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

totalprojs = PROJimp.nproj + PROJimp.nprojrc;
figure(53)
hold on
axis equal;
grid on;
phi = projdist.IV(1,:);
theta = projdist.IV(2,:);
for i = 1:totalprojs 
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
for i = 1:totalprojs
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end
%error('testing');
