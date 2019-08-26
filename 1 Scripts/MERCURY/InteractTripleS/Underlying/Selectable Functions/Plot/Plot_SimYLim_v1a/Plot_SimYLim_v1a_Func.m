%======================================================
% 
%======================================================

function [PLOT,err] = Plot_SimYLim_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Simulation',2);
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
% Get Input
%---------------------------------------------
ylimvals = textscan(PLOT.ylim,'%f');
ylimvals = ylimvals{1};
figsize = textscan(PLOT.figsize,'%f');
figsize = figsize{1};

%---------------------------------------------
% Plot Stuff
%---------------------------------------------
figloc = [8 6];
figarr = [figloc figsize.'];
linewidth = 1;

%---------------------------------------------
% Plot
%---------------------------------------------
clr = {'r-','b-','g-','m-','c-','y'};
hFig = figure(134560891); 
%clf;
hold on;
sz = size(SIM.Val);
for n = 1:sz(2)
    plot(SIM.Time,SIM.Val(:,n),clr{n},'linewidth',linewidth);
end
plot([0 max(SIM.Time)],[0 0],'k:');

SegBounds = APP.SIM.ARR.SegBounds;
for n = 2:length(SegBounds)-1
    if SegBounds(n) < 0.01*max(SegBounds) || SegBounds(n) > 0.99*max(SegBounds)
        continue
    end
    plot([SegBounds(n) SegBounds(n)],[-100 100],'k:');
end

hFig.Units = 'Inches';
hFig.Position = figarr;

hAx = gca;
hAx.XLim = [0 max(SIM.Time)];
hAx.YLim = ylimvals;
hAx.XLabel.String = 'ms';
hAx.YLabel.String = SIM.YLabel;
if mean(figsize > 5)
    hAx.Position = [0.125 0.125 0.8 0.8];
else
    hAx.Position = [0.175 0.175 0.7 0.7];
end
box on;

%----------------------------------------------------
% Return
%----------------------------------------------------
PLOT.Figure.Name = PLOT.method;
PLOT.Figure.Type = 'Graph';
PLOT.Figure.hFig = hFig;
PLOT.Figure.hAx = hAx;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Plot',PLOT.method,'Output'};
PLOT.Panel = Panel;
PLOT.PanelOutput = cell2struct(PLOT.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);
