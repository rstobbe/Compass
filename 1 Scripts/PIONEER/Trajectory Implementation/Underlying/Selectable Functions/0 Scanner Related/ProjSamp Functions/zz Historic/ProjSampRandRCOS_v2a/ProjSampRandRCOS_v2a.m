%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRandRCOS_v2a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
RCOS = str2double(SCRPTipt(strcmp('RCOS',{SCRPTipt.labelstr})).entrystr);
minreldist = str2double(SCRPTipt(strcmp('MinRelDistTot',{SCRPTipt.labelstr})).entrystr);
minreldistimp = str2double(SCRPTipt(strcmp('MinRelDistImp',{SCRPTipt.labelstr})).entrystr);

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
else
    PROJimp.nproj = PROJdgn.nproj;
    
    osampphi = 1;
    osamptheta = 1;
    thphistep = pi/(2*ceil((pi*rad*osampphi)/2)-1);
    
    phi = acos(2*rand(1,totalprojs)-1);
    theta = 2*pi*rand(1,totalprojs);  
    m = 1;
    for n = 1:totalprojs
        phistep = phi(n)-phi;
        inds01 = find(abs(phistep) < minreldist*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds01));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds1 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*p)));
        inds02 = find((abs(phistep) >= minreldist*thphistep/4) & (abs(phistep) < 2*minreldist*thphistep/4)); 
        magthetastep = abs(theta(n) - theta(inds02));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds2 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*((1+p)/2))));
        inds03 = find(abs(phistep) >= 2*minreldist*thphistep/4 & abs(phistep) < 3*minreldist*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds03));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds3 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta)));
        if length(inds1) == 1 && isempty(inds2) && isempty(inds3)
            phigood(m) = phi(n);
            thetagood(m) = theta(n);
            m = m+1;
        end
    end
    loopcntr = 1;
    while m-1 < totalprojs 
        phi2 = acos(2*rand(1,totalprojs-m+1)-1);
        theta2 = 2*pi*rand(1,totalprojs-m+1);
        phi = [phigood phi2];
        theta = [thetagood theta2]; 
        for n = m:totalprojs
            phistep = phi(n)-phi;
            inds01 = find(abs(phistep) < minreldist*thphistep/4); 
            magthetastep = abs(theta(n) - theta(inds01));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds1 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*p)));
            inds02 = find((abs(phistep) >= minreldist*thphistep/4) & (abs(phistep) < 2*minreldist*thphistep/4)); 
            magthetastep = abs(theta(n) - theta(inds02));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds2 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*((1+p)/2))));
            inds03 = find(abs(phistep) >= 2*minreldist*thphistep/4 & abs(phistep) < 3*minreldist*thphistep/4); 
            magthetastep = abs(theta(n) - theta(inds03));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds3 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta)));
            if length(inds1) == 1 && isempty(inds2) && isempty(inds3)
                phigood(m) = phi(n);
                thetagood(m) = theta(n);
                m = m+1;
            end
        end
        loopcntr = loopcntr + 1
    end
    
    %------------------------------------
    % Test
    %------------------------------------
    phi = phigood;
    theta = thetagood;
    for n = 1:totalprojs
        phistep = phi(n)-phi;
        inds01 = find(abs(phistep) < minreldist*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds01));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds1 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*p)));
        inds02 = find((abs(phistep) >= minreldist*thphistep/4) & (abs(phistep) < 2*minreldist*thphistep/4)); 
        magthetastep = abs(theta(n) - theta(inds02));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds2 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta*((1+p)/2))));
        inds03 = find(abs(phistep) >= 2*minreldist*thphistep/4 & abs(phistep) < 3*minreldist*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds03));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds3 = find(magthetastep < (minreldist/(sin(phi(n))*rad*osamptheta)));
        if length(inds1) > 1 && not(isempty(inds2)) && not(isempty(inds3))
            error();
        end
    end
    projdist.IV(1,:) = phi; 
    projdist.IV(2,:) = theta; 
    
    %------------------------------------
    % Select Imp Set
    %------------------------------------
    phigood = [];
    thetagood = [];
    phi = projdist.IV(1,1:PROJimp.nproj);
    theta = projdist.IV(2,1:PROJimp.nproj);
    m = 1;
    for n = 1:PROJimp.nproj
        phistep = phi(n)-phi;
        inds01 = find(abs(phistep) < minreldistimp*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds01));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds1 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta*p)));
        inds02 = find((abs(phistep) >= minreldistimp*thphistep/4) & (abs(phistep) < 2*minreldistimp*thphistep/4)); 
        magthetastep = abs(theta(n) - theta(inds02));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds2 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta*((1+p)/2))));
        inds03 = find(abs(phistep) >= 2*minreldistimp*thphistep/4 & abs(phistep) < 3*minreldistimp*thphistep/4); 
        magthetastep = abs(theta(n) - theta(inds03));
        magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
        inds3 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta)));
        if length(inds1) == 1 && isempty(inds2) && isempty(inds3)
            phigood(m) = phi(n);
            thetagood(m) = theta(n);
            projgood(m) = n;
            m = m+1;
        end
    end
    loopcntr = 1;
    projcntr = PROJimp.nproj+1;
    while m-1 < PROJimp.nproj 
        phi2 = projdist.IV(1,projcntr:projcntr+PROJimp.nproj-m+1);
        theta2 = projdist.IV(2,projcntr:projcntr+PROJimp.nproj-m+1);
        phi = [phigood phi2];
        theta = [thetagood theta2]; 
        for n = m:PROJimp.nproj
            phistep = phi(n)-phi;
            inds01 = find(abs(phistep) < minreldistimp*thphistep/4); 
            magthetastep = abs(theta(n) - theta(inds01));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds1 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta*p)));
            inds02 = find((abs(phistep) >= minreldistimp*thphistep/4) & (abs(phistep) < 2*minreldistimp*thphistep/4)); 
            magthetastep = abs(theta(n) - theta(inds02));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds2 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta*((1+p)/2))));
            inds03 = find(abs(phistep) >= 2*minreldistimp*thphistep/4 & abs(phistep) < 3*minreldistimp*thphistep/4); 
            magthetastep = abs(theta(n) - theta(inds03));
            magthetastep(magthetastep > pi) = 2*pi - magthetastep(magthetastep > pi);
            inds3 = find(magthetastep < (minreldistimp/(sin(phi(n))*rad*osamptheta)));
            if length(inds1) == 1 && isempty(inds2) && isempty(inds3)
                phigood(m) = phi(n);
                thetagood(m) = theta(n);
                projgood(m) = n;
                m = m+1;
            end
            projcntr = projcntr+1;
        end
        loopcntr = loopcntr + 1
    end    
    PROJimp.impprojs = projgood;
    PROJimp.projdist = projdist;
end

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nprojrc','0output',PROJimp.nprojrc,'0numout');

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

figure(53)
hold on
axis equal;
grid on;
phi = projdist.IV(1,PROJimp.impprojs);
theta = projdist.IV(2,PROJimp.impprojs);
for i = 1:PROJimp.nproj  
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'*');
end
figure(54)
hold on
axis equal;
grid on;
for i = 1:PROJimp.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end
