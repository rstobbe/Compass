%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpkSpaceOrtho_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-Space (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
PROJdgn = IMP.DES.PROJdgn;
samp0 = IMP.samp;
Kmat = IMP.Kmat;
clear INPUT

samp = samp0 - 2*samp0(1) + samp0(2); 

Rad = (Kmat(N,:,1).^2 + Kmat(N,:,2).^2 + Kmat(N,:,3).^2).^0.5;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
hFig = figure(1000); hold on; box on;
plot(samp,Kmat(N,:,1),'b-'); plot(samp,Kmat(N,:,2),'g-'); plot(samp,Kmat(N,:,3),'r-');
plot(samp,Rad,'k');
title(['Traj',num2str(1)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
xlim([0 samp(end)]);
ylim([-PROJdgn.kmax PROJdgn.kmax]);
%xlim([0 5]);
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'kSpaceOrtho';
fig = 1;
PLOT.Figure(fig).Name = 'kSpaceOrtho';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;