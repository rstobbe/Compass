%======================================================
% 
%======================================================

function [PLOT,err] = Plot_SimStandard_v1a_Func(PLOT,INPUT)

Status2('busy','Plot',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
SIM = INPUT.SIM;
clear INPUT

%---------------------------------------------
% Plot Stuff
%---------------------------------------------
labelfont = 10;
axisfont = 10;
%graphsize = [8 6 8 5];
graphsize = [8 6 3.5 2.5];
linewidth = 1;

%---------------------------------------------
% Plot
%---------------------------------------------
clr = {'r-','b-','g-','m-','c-','y'};
h = figure(13456089); clf; hold on;
sz = size(SIM.Val);
for n = 1:sz(2)
    plot(SIM.Time,SIM.Val(:,n),clr{n},'linewidth',linewidth);
end
plot([0 max(SIM.Time)],[0 0],'k:');

SegBounds = APP.SIM.ARR.SegBounds;
for n = 2:length(SegBounds)-1
    plot([SegBounds(n) SegBounds(n)],[-100 100],'k:');
end

if min(SIM.Val(:)) < 0
    ylim([-100 100]);
else
    ylim([0 100]);
end
xlim([0 max(SIM.Time)]);
set(gca,'fontsize',axisfont);
set(gca,'fontweight','bold');
set(gca,'xticklabelmode','auto');
xlabel('(ms)','fontsize',labelfont);
ylabel(SIM.YLabel,'fontsize',labelfont);
set(h,'units','inches');
set(h,'position',graphsize);
%set(gca,'Position',[0.12 0.12 0.8 0.8]);
box on;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Plot',PLOT.method,'Output'};
PLOT.Panel = Panel;
PLOT.PanelOutput = cell2struct(PLOT.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);
