%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_StdTPIRadEvo_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Radial Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
PROJdgn = INPUT.IMP.DES.PROJdgn;
samp0 = IMP.samp;
Kmat = IMP.Kmat;
clear INPUT

%---------------------------------------------
% Build Standard TPI
%---------------------------------------------
rad = (Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2).^0.5;
rad = mean(rad,1);
rad = rad/max(rad);
ind = find(rad >= PROJdgn.p,1,'first');

rad = [0 rad(ind:end)];
rad = rad/max(rad);

samp = samp0(ind:end)-samp0(ind);
samp = PROJdgn.TPIiseg + ((PROJdgn.tro-PROJdgn.TPIiseg)/samp(end))*samp;
samp = [0 samp];

fh = figure(1000); hold on; box on;
plot(samp,rad,'k-');
title('Radial Evolution');
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
%xlim([0 samp(end)]);
xlim([0 5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];