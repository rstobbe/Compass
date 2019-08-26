%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpFinalPtProj3D_v1a_Func(PLOT,INPUT)

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

%KmatEnd = squeeze(IMP.Kmat(:,end,:));
KmatEnd = squeeze(IMP.Kmat(:,400,:));
lim = IMP.PROJdgn.kmax;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
hFig = figure(1000); hold on; axis equal; grid on; box off;
for n = 1:84:length(KmatEnd)
%for n = 1:84
    plot3([0 KmatEnd(n,1)],[0 KmatEnd(n,2)],[0 KmatEnd(n,3)],'b-','linewidth',0.5);
end
xlabel('k_x (1/m)'); ylabel('k_y (1/m)'); zlabel('k_z (1/m)');
set(gca,'cameraposition',[-10000 -18000 2500]);
xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
% set(gca,'xtick',(-500:500:500));
% set(gca,'ytick',(-500:500:500));
% set(gca,'ztick',(-500:500:500));
set(gca,'xtick',(-1000:1000:1000));
set(gca,'ytick',(-1000:1000:1000));
set(gca,'ztick',(-1000:1000:1000));

error

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