%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRandRCOS_v2a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
RCOS = str2double(SCRPTipt(strcmp('RCOS',{SCRPTipt.labelstr})).entrystr);

mindist = 0.2;

projdist.sym = 1;
rad = PROJdgn.rad;
p = PROJdgn.p;
projdist.thnproj = round((4*pi*(rad)^2)*p);
projdist.RCOS = RCOS;
totalprojs = round(projdist.thnproj*RCOS);
PROJimp.nprojrc = totalprojs - PROJdgn.nproj;

mindist = mindist/p;

if SCRPTGBL.testing == 1
    PROJimp.nproj = PROJimp.tnproj;
    projdist.IV(1,:) = linspace(0,pi/2,PROJimp.nproj);
    projdist.IV(2,:) = zeros(1,PROJimp.nproj);
else
    PROJimp.nproj = PROJdgn.nproj;  
    phi = acos(2*rand(1,totalprojs)-1);
    theta = 2*pi*rand(1,totalprojs);
    x = rad*sin(phi).*cos(theta);
    y = rad*sin(phi).*sin(theta);
    z = rad*cos(phi);  
    m = 1;
    for n = 1:totalprojs
        dist = ((x(n)-x).^2 + (y(n)-y).^2 + (z(n)-z).^2).^(1/2);   
        ind = find(dist < mindist);
        if length(ind) == 1
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
        x = rad*sin(phi).*cos(theta);
        y = rad*sin(phi).*sin(theta);
        z = rad*cos(phi);  
        for n = m:totalprojs
            dist = ((x(n)-x).^2 + (y(n)-y).^2 + (z(n)-z).^2).^(1/2);   
            ind = find(dist < mindist);
            if length(ind) == 1
                phigood(m) = phi(n);
                thetagood(m) = theta(n);
                m = m+1;
            end
        end
        loopcntr = loopcntr + 1
    end
    phi = phigood;
    theta = thetagood;
    x = rad*sin(phi).*cos(theta);
    y = rad*sin(phi).*sin(theta);
    z = rad*cos(phi);  
    for n = 1:totalprojs
        dist = ((x(n)-x).^2 + (y(n)-y).^2 + (z(n)-z).^2).^(1/2);   
        ind = find(dist < mindist);
        if length(ind) > 1
            error();
        end
    end
    projdist.IV(1,:) = phi; 
    projdist.IV(2,:) = theta; 
end

PROJimp.projdist = projdist;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nprojrc','0output',PROJimp.nprojrc,'0numout');

figure(51)
hold on
axis equal;
grid on;
phi = projdist.IV(1,:);
theta = projdist.IV(2,:);
for i = 1:PROJimp.nproj 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'*');
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:PROJimp.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end

test = 0;



%phivalues = acos(2*rand(1,10000000)-1);
%figure(2)
%hist(values,40);