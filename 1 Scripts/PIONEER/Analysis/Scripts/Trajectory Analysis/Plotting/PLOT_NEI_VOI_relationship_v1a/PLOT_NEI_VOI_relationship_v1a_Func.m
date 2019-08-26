%======================================================
% 
%======================================================

function [ANLZ,err] = PLOT_NEI_VOI_relationship_v1a_Func(ANLZ,INPUT)

Status('busy','Plot NEI - VOI relationship');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ = INPUT.ANLZ;
clear INPUT

%---------------------------------------------
% Cut at 1 voxel in VOI
%---------------------------------------------
% nroi = ANLZ.nroi;
% rnei = ANLZ.rnei;
% rnei(nroi < 1) = NaN;
% 
% ind = find(isnan(nroi));
% if isempty(ind)
%     rnei1 = interp1(nroi,ANLZ.rnei,1);
% else
%     rnei1 = interp1(nroi(ind(end)+1:end,n),ANLZ.rnei(ind(end)+1:end,n),1);
% end
% rnei = [rnei1,rnei];

%---------------------------------------------
% Plot
%---------------------------------------------
% figure(999); hold on;
% for n = 1:3
%     plot(nob(~isnan(rnei(:,n)),n)*((0.1*ANLZ.PROJdgn.vox)^3),rnei(~isnan(rnei(:,n)),n),'g-');
% end  
% box on;
% xlim([0.0625 16]); 
% ylim([0 0.1]); 
% h = gca;
% h.XTick = [0.0625 0.25 1 4 16];
% set(gca,'XScale','log');
% 
% set(gcf,'units','inches');
% set(gcf,'position',[3 3 3 2.5]);
% set(gcf,'paperpositionmode','auto');
% set(gca,'units','inches');
% set(gca,'position',[0.5 0.5 2 1.6]);
% set(gca,'fontsize',10,'fontweight','bold');


%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); 
hold on;
plot(ANLZ.nroi,100*ANLZ.rnei*ANLZ.snr);
box on;
%ylim([0 0.11]);
h = gca;
ylim([0 180]); 
h.YTick = [0 30 60 90 120 150 180];
xlim([1 256]); 
h.XTick = [1 4 16 64 256];
set(gca,'XScale','log');

set(gcf,'units','inches');
set(gcf,'position',[3 3 3 2.5]);
set(gcf,'paperpositionmode','auto');
set(gca,'units','inches');
set(gca,'position',[0.5 0.5 2 1.8]);
set(gca,'fontsize',10,'fontweight','bold');

%---------------------------------------------
% Return
%---------------------------------------------  
ANLZ.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);