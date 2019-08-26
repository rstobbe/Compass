%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpkSpace3D_v1d_Func(PLOT,INPUT)

Status2('busy','Plot Radial Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
clear INPUT

%Kmat = squeeze(IMP.Kmat(N,:,:));
Kmat = squeeze(IMP.Kmat);
sz = size(Kmat);
lim = IMP.PROJdgn.kmax;
% lim = IMP.PROJdgn.kmax*0.5;
% Kmat = Kmat(:,1:50,:);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
hFig = figure(1001); hold on; axis equal; grid on; box off;
for n = 1
    plot3(squeeze(Kmat(n,:,1)),squeeze(Kmat(n,:,2)),squeeze(Kmat(n,:,3)),'k-','linewidth',0.5);
end
% for n = [1 10]
%     plot3(squeeze(Kmat(n,:,1)),squeeze(Kmat(n,:,2)),squeeze(Kmat(n,:,3)),'k-','linewidth',0.5);
% end
% for n = 19:36
%     plot3(squeeze(Kmat(n,:,1)),squeeze(Kmat(n,:,2)),squeeze(Kmat(n,:,3)),'r-','linewidth',0.5);
% end
clr = ['r' 'b' 'g' 'c' 'm' 'y' 'k' 'r'];
%for Off = 0:8:120
% for Off = 0
%     for n = 1:8
%         plot3(squeeze(Kmat(Off+n,:,1)),squeeze(Kmat(Off+n,:,2)),squeeze(Kmat(Off+n,:,3)),[clr(n),'-'],'linewidth',0.5);
%     end
% end
xlabel('k_x (1/m)'); ylabel('k_y (1/m)'); zlabel('k_z (1/m)');
set(gca,'cameraposition',[-10000 -18000 2500]);
xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
% set(gca,'xtick',(-500:500:500));
% set(gca,'ytick',(-500:500:500));
% set(gca,'ztick',(-500:500:500));
set(gca,'xtick',(-1000:1000:1000));
set(gca,'ytick',(-1000:1000:1000));
set(gca,'ztick',(-1000:1000:1000));

hFig.Units = 'Inches';
%sz = 2.1;
sz = 4;
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