%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_InitProjVec_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

projdist = SCRPTGBL.PROJimp.projdist;
rad = SCRPTGBL.PROJdgn.rad;

figure(51)
hold on
axis equal;
grid on;
phi = projdist.IV(1,:);
theta = projdist.IV(2,:);
%plot(rad*sin(phi(1))*cos(theta(1)),rad*sin(phi(1))*sin(theta(1)),'g*');
%plot(rad*sin(phi(751))*cos(theta(751)),rad*sin(phi(751))*sin(theta(751)),'m*');
for i = 1:projdist.nproj/2 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'b*');
end
for i = projdist.nproj/2+1:projdist.nproj 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'r*');
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:projdist.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end


x = rad*sin(phi).*cos(theta);
y = rad*sin(phi).*sin(theta);
z = rad*cos(phi);  
for n = 1:projdist.ncones 
    for m = 1:projdist.nprojcone(n)
        projno = projdist.projindx{n}(m);
        dist = ((x(projno)-x).^2 + (y(projno)-y).^2 + (z(projno)-z).^2).^(1/2);
        mindist(m) = min([dist(1:projno-1) dist(projno+1:length(dist))]);
    end
    mindistcone(n) = mean(mindist);
end

figure(53)
plot(projdist.conephi,mindistcone);