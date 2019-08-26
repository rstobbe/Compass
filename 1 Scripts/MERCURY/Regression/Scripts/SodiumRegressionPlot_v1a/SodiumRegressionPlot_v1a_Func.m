%=========================================================
% 
%=========================================================

function [PLOT,err] = SodiumRegressionPlot_v1a_Func(PLOT,INPUT)

Status('busy','Plot');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY = INPUT.STUDY;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
REG = STUDY.REG;
hFig = figure(12341); hold on; box on;
plot(REG.DataArr,'k*');
plot(REG.DataArr+REG.Residual,'r*');
ylim([0 25]);
xlim([0 46]);

hFig.Units = 'Inches';
%sz = 2.1;
sz = 3;
hFig.Position = [12 10 sz sz*0.75];
hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
fig = 1;
PLOT.Figure(fig).Name = '23NaRegression';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};

PLOT.name = '';
PLOT.Panel = Panel;
PLOT.PanelOutput = cell2struct(PLOT.Panel,{'label','value','type'},2);
PLOT.ExpDisp = PanelStruct2Text(PLOT.PanelOutput);

Status2('done','',2);
Status2('done','',3);
