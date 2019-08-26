%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_ImpkSpaceOrthoMultiEchoSelect_v1d_Func(PLOT,INPUT)

Status2('busy','Plot kSpace 3D',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
WFMS = IMP.KSMP.ExtraSave;
clear INPUT


%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on; box on;
plot(WFMS.Samp0,squeeze(WFMS.Kmat0(PLOT.trajnum,:,1)),'b');
plot(WFMS.Samp0,squeeze(WFMS.Kmat0(PLOT.trajnum,:,2)),'g');
plot(WFMS.Samp0,squeeze(WFMS.Kmat0(PLOT.trajnum,:,3)),'r');

plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,1,1)),'b','linewidth',2);
plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,2,1)),'g','linewidth',2);
plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,3,1)),'r','linewidth',2);
plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,1,2)),'b','linewidth',2);
plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,2,2)),'g','linewidth',2);
plot(WFMS.Samp0,squeeze(WFMS.KmatDisplay(:,3,2)),'r','linewidth',2);
xlim([0 2.66]);
ylim([-800 800]);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
% figure(1001); hold on; axis equal; grid on; box off;
% plot3(WFMS.KmatDisplay(:,1,3),WFMS.KmatDisplay(:,2,3),WFMS.KmatDisplay(:,3,3),'k-','linewidth',1);
% plot3(WFMS.KmatDisplay(:,1,1),WFMS.KmatDisplay(:,2,1),WFMS.KmatDisplay(:,3,3),'m-','linewidth',2);
% plot3(WFMS.KmatDisplay(:,1,2),WFMS.KmatDisplay(:,2,2),WFMS.KmatDisplay(:,3,3),'c-','linewidth',2);
% xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
% set(gca,'cameraposition',[-4000 -5000 1000]);
% lim = 800;
% xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
% figure(1000); hold on;
% plot(IMP.samp,squeeze(IMP.Kmat(PLOT.trajnum,:,1,PLOT.echonum)),'b');
% plot(IMP.samp,squeeze(IMP.Kmat(PLOT.trajnum,:,2,PLOT.echonum)),'g');
% plot(IMP.samp,squeeze(IMP.Kmat(PLOT.trajnum,:,3,PLOT.echonum)),'r');
% 
% figure(1001); hold on;
% plot(squeeze(IMP.Kmat(PLOT.trajnum,:,1,PLOT.echonum)),'b');
% plot(squeeze(IMP.Kmat(PLOT.trajnum,:,2,PLOT.echonum)),'g');
% plot(squeeze(IMP.Kmat(PLOT.trajnum,:,3,PLOT.echonum)),'r');