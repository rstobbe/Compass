%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpRadEvo_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-Space (3D)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.DES.PROJdgn;
samp = IMP.samp;
Kmat = IMP.Kmat;
clear INPUT

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
samp = samp - samp(1);

%---
%samp = PROJdgn.tro*samp/samp(end);
%---

rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rad = squeeze(mean(rad,1));

%rad = rad/max(rad);
rad = rad/PROJdgn.kmax;
%rad = rad*PROJdgn.kmax;

fh = figure(1000); hold on; box on;
plot(samp,rad,'k-');
%title('Radial Evolution');
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
ylim([0 1.0]);
xlim([0 round(samp(end))]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];



% drad = rad(2:end) - rad(1:end-1);
% 
% fh = figure(1001); hold on; box on;
% plot(samp(2:end),drad,'k-');
% title('dRadial Evolution');
% xlabel('(ms)','fontsize',10,'fontweight','bold');
% ylabel('Radial Derivative','fontsize',10,'fontweight','bold');
% %xlim([0 samp(end)]);
% %xlim([0 2]);
% %ylim([0 1.1]);
% xlim([0 samp(end)]);
% fh.Units = 'inches';
% fh.Position = [5 5 3 2.4];


% Kmat = Kmat/PROJdgn.kmax;
% TrajDif = squeeze(Kmat(:,2:end,:,1) - Kmat(:,1:end-1,:,1));
% 
% TrajSegs = sqrt(TrajDif(:,:,1).^2 + TrajDif(:,:,2).^2 + TrajDif(:,:,3).^2);
% TrajSegs = mean(TrajSegs,1);
% 
% TrajLen = sum(TrajSegs)
% 
% figure(125); hold on;
% plot(TrajSegs);

Status2('done','',2);
Status2('done','',3);

