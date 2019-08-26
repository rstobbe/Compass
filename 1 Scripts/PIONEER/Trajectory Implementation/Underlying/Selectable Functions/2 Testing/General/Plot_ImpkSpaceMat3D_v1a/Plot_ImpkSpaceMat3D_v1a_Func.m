%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpkSpaceMat3D_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-Space Matrix 3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
Kmat = squeeze(IMP.Kmat)/IMP.PROJdgn.kstep;
lim = IMP.PROJdgn.kmax/IMP.PROJdgn.kstep;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
sz = size(Kmat);
hFig = figure(1001); hold on; axis equal; grid on; box off;

if strcmp(PLOT.trajnum,'All')
    for n = 1:sz(1)
        plot3(squeeze(Kmat(n,:,1)),squeeze(Kmat(n,:,2)),squeeze(Kmat(n,:,3)),'k-','linewidth',0.5);
    end
else
    N = str2double(PLOT.trajnum);
    plot3(squeeze(Kmat(N,:,1)),squeeze(Kmat(N,:,2)),squeeze(Kmat(N,:,3)),'k-','linewidth',0.5);
end

xlabel('k_x (steps)'); ylabel('k_y (steps)'); zlabel('k_z (steps)');
%set(gca,'cameraposition',[0 0 10000]);
set(gca,'cameraposition',[-10000 -18000 2500]);
xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
set(gca,'xtick',(-10:10:10));
set(gca,'ytick',(-10:10:10));
set(gca,'ztick',(-10:10:10));
%box on;

hFig.Units = 'Inches';
%sz = 2.5;
sz = 3;
hFig.Position = [12 10 sz sz*0.75];
hAx = gca;
hAx.Position = [0.25 0.1 0.6 0.9];

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'kSpace3D';
fig = 1;
PLOT.Figure(fig).Name = 'kSpace3D';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;

Status2('done','',2);
Status2('done','',3);