%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_ImpkSpace3DMultiEchoSelect_v1d_Func(PLOT,INPUT)

Status2('busy','Plot kSpace 3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
clear INPUT

KmatDisplay = IMP.KSMP.ExtraSave.KmatDisplay;

h = figure(1000); hold on; axis equal; grid on; box off;
set(gca,'cameraposition',[-800 -1000 160]); 
clrarr = {'m','c'};
plot3(KmatDisplay(:,1,end),KmatDisplay(:,2,end),KmatDisplay(:,3,end),'k-');
for n = 1:2
    plot3(KmatDisplay(:,1,n),KmatDisplay(:,2,n),KmatDisplay(:,3,n),clrarr{n},'linewidth',2);
end
xlabel('k_x (1/m)'); ylabel('k_y (1/m)'); zlabel('k_z (1/m)'); title('Final Trajectory');
xlim([-750 750]);
ylim([-750 750]);
zlim([-750 750]);
h.Units = 'Inches';
h.Position = [5 5 3.5 3.5];

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
% lim = IMP.PROJdgn.kmax;
% GWFM = IMP.GWFM
% figure(1000); hold on; axis equal; grid on; box off;
% 
% Kmat = squeeze(IMP.Kmat(PLOT.trajnum,:,:,PLOT.echonum));
% 
% plot3(Kmat(:,1),Kmat(:,2),Kmat(:,3),'k-','linewidth',2);
% xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
% set(gca,'cameraposition',[-310 -390 125]);
% xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
% set(gca,'xtick',(-500:500:500));
% set(gca,'ytick',(-500:500:500));
% set(gca,'ztick',(-500:500:500));