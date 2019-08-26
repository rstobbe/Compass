%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DesGradSlew_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradient Slew',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
KSA = DES.KSA;
T0 = DES.T0;
clear INPUT

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
[vel,Tvel0] = CalcVelMulti_v2a(KSA*PROJdgn.kmax,T0);
[acc,Tacc0] = CalcAccMulti_v2a(vel,Tvel0);
[jerk,Tjerk0] = CalcJerkMulti_v2a(acc,Tacc0);
magvel0 = sqrt(vel(:,:,1).^2 + vel(:,:,2).^2 + vel(:,:,3).^2);
magacc0 = sqrt(acc(:,:,1).^2 + acc(:,:,2).^2 + acc(:,:,3).^2);
magjerk0 = sqrt(jerk(:,:,1).^2 + jerk(:,:,2).^2 + jerk(:,:,3).^2);  

rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
rad = squeeze(mean(rad,1));
rad = rad/max(rad);

%gamma = 11.26;
gamma = 42.577;

% sz = size(magacc0);
% maxmagacc = magacc0(sz(1)-1,:);
% maxmagacc(1) = 0;

hFig = figure(1000); hold on; box on;
plot(Tacc0,magacc0/gamma,'k-');
%plot(Tacc0,maxmagacc/gamma,'b-');
title('Gradient Slew');
xlabel('(mT/m/ms)','fontsize',10,'fontweight','bold');
ylabel('(ms)','fontsize',10,'fontweight','bold');
xlim([0 10]);
ylim([0 250]);
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'GradSlew';
fig = 1;
PLOT.Figure(fig).Name = 'GradSlew';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;

