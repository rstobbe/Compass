%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_DesRadEvo_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Radial Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

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
rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
rad = squeeze(mean(rad,1));

rad = rad/max(rad);

fh = figure(1000); hold on; box on;
plot(T0,rad,'k-');
title('Radial Evolution');
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
%xlim([0 samp(end)]);
xlim([0 2]);
ylim([0 0.7]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];