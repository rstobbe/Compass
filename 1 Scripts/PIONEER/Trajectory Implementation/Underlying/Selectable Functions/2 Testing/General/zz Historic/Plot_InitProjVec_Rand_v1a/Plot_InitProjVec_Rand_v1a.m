%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_InitProjVec_Rand_v1a(SCRPTipt,SCRPTGBL)

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
for i = 1:SCRPTGBL.PROJimp.nproj 
    plot(rad*sin(phi(i))*cos(theta(i)),rad*sin(phi(i))*sin(theta(i)),'*');
end
figure(52)
hold on
axis equal;
grid on;
for i = 1:SCRPTGBL.PROJimp.nproj 
    plot(rad*cos(phi(i)),rad*sin(phi(i)),'*');
end


