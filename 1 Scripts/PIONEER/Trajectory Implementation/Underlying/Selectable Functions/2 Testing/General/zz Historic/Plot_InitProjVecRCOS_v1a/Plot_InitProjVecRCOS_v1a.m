%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_InitProjVec_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

projdist0 = SCRPTGBL.PROJimp.projdist0;
projdistrc = SCRPTGBL.PROJimp.projdistrc;
rad = SCRPTGBL.PROJdgn.rad;

figure(51)
hold on
axis equal;
grid on;
nprojcone0 = projdist0.nprojcone
phi = projdist0.IV(1,:);
theta = projdist0.IV(2,:);
for i = 1:projdist0.nproj 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'*');
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:projdist0.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end

figure(51)
nprojconerc = projdistrc.nprojcone
phi = projdistrc.IV(1,:);
theta = projdistrc.IV(2,:);
for i = 1:projdistrc.nproj
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'r*');
end
figure(52)
for i = 1:projdistrc.nproj
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'r*');
end

