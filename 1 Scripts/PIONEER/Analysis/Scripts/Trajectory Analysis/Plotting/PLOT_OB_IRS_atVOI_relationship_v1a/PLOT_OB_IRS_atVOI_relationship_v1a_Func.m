%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_OB_IRS_atVOI_relationship_v1a_Func(PLOT,INPUT)

Status('busy','Plot OB - IRS @ VOI relationship');
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
% Plot
%---------------------------------------------
% figure(999); hold on;
% plot(ANLZ.nob,ANLZ.nroi);

%---------------------------------------------
% Cut at 1 voxel in VOI
%---------------------------------------------
nroi = ANLZ.nroi;
meanirs = ANLZ.meanirs;
meanirs(nroi < 1) = NaN;

for n = 1:3
    ind = find(isnan(nroi(:,n)));
    if isempty(ind)
        meanirs1(n) = interp1(nroi(:,n),ANLZ.meanirs(:,n),1);
        nob1 = interp1(nroi(:,n),ANLZ.nob,1);
    else
        meanirs1(n) = interp1(nroi(ind(end)+1:end,n),ANLZ.meanirs(ind(end)+1:end,n),1);
        nob1 = interp1(nroi(ind(end)+1:end,n),ANLZ.nob(ind(end)+1:end),1);
    end
    nob(:,n) = [nob1,ANLZ.nob];
end
meanirs = [meanirs1;meanirs];
    
%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000);  hold on;
for n = 1:3
    plot(nob(~isnan(meanirs(:,n)),n),meanirs(~isnan(meanirs(:,n)),n)*100,'b-');
end    
box on;
h = gca;
xlim([1 256]);
h.XTick = [1 4 16 64 256];
ylim([0 100]); 
h.YTick = [0 20 40 60 80 100 120];
%ylim([0 150]); 
%h.YTick = [0 25 50 75 100 125 150];
set(gca,'XScale','log');
set(gcf,'units','inches');
set(gcf,'position',[3 3 3 2.5]);
set(gcf,'paperpositionmode','auto');
set(gca,'units','inches');
set(gca,'position',[0.5 0.5 2 1.8]);
set(gca,'fontsize',10,'fontweight','bold');

%---------------------------------------------
% Plot
%---------------------------------------------
% figure(1001);  hold on;
% for n = 1:3
%     plot(nob(~isnan(meanirs(:,n)),n)*((0.1*ANLZ.PROJdgn.vox)^3),meanirs(~isnan(meanirs(:,n)),n),'g-');
% end  
% box on;
% ylim([0 1]); 
% xlim([0.0625 16]); 
% h = gca;
% h.XTick = [0.0625 0.25 1 4 16];
% set(gca,'XScale','log');
% set(gcf,'units','inches');
% set(gcf,'position',[3 3 3 2.5]);
% set(gcf,'paperpositionmode','auto');
% set(gca,'units','inches');
% set(gca,'position',[0.5 0.5 2 1.6]);
% set(gca,'fontsize',10,'fontweight','bold');

%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);