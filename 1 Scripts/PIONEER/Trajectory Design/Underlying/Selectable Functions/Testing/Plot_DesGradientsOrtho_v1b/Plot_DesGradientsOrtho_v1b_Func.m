%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DesGradientsOrtho_v1b_Func(PLOT,INPUT)

Status2('busy','Plot Design Gradients (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
clear INPUT

T0 = DES.T0;
KSA = DES.KSA*PROJdgn.kmax;

%G = SolveGradQuant_v1b(T0,KSA,11.26);
G = SolveGradQuant_v1b(T0,KSA,42.577);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Gmag = (G(1,:,1).^2 + G(1,:,2).^2 + G(1,:,3).^2).^0.5;
hFig = figure(999); hold on; box on;
plot(T0,[0 squeeze(G(N,:,1))],'b-'); plot(T0,[0 squeeze(G(N,:,2))],'g-'); plot(T0,[0 squeeze(G(N,:,3))],'r-');
plot(T0,[0 Gmag],'k-');
ylim([-50 50]);
xlim([0 10]);
title(['Traj',num2str(N)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
% [A,B,C] = size(G);
% Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
% for n = 1:length(T0)-1
%     L((n-1)*2+1) = T0(n);
%     L(n*2) = T0(n+1);
%     Gvis(:,(n-1)*2+1,:) = G(:,n,:);
%     Gvis(:,n*2,:) = G(:,n,:);
% end
% Gmag = (Gvis(1,:,1).^2 + Gvis(1,:,2).^2 + Gvis(1,:,3).^2).^0.5;
% 
% hFig = figure(1000); hold on; box on;
% plot(L,Gvis(N,:,1),'b-'); plot(L,Gvis(N,:,2),'g-'); plot(L,Gvis(N,:,3),'r-');
% plot(L,Gmag,'k-');
% ylim([-50 50]);
% % xlim([0 5]);
% title(['Traj',num2str(N)]);
% xlabel('(ms)','fontsize',10,'fontweight','bold');
% ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
% hFig.Units = 'inches';
% hFig.Position = [5 5 3 2.4];
% hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'GradOrtho';
fig = 1;
PLOT.Figure(fig).Name = 'GradOrtho';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;

