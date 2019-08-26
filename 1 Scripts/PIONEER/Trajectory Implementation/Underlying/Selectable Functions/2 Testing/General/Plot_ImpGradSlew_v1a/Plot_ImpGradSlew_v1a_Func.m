%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpGradSlew_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradient Slew',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
G = IMP.G;
GQNT.gseg = 0.01;
qT = IMP.qTscnr;
clear INPUT

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(G(1,:,1))-2);
cartgsteps = [G(:,1,:) G(:,m,:)-G(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);

hFig = figure(1000); 
plot(qT(2:length(qT)-2),maxmaggsteps/GQNT.gseg,'k-');
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
