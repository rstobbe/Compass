%======================================================
% 
%======================================================

function [PLOT,err] = Plot_SimFT_v1a_Func(PLOT,INPUT)

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

AcqElm = APP.SIM.AcqElm;
ARR = APP.SIM.ARR;
ind = find(ARR.time == ARR.SegBounds(AcqElm));
AcqVals = SIM.Val(ind:end,:);
AcqVals = [AcqVals(1:end-1);flip(AcqVals(2:end),1)];

step = SIM.Time(ind+1) - SIM.Time(ind);
FreqMax = 1/(2*step);
FreqStep = (FreqMax*2)/length(AcqVals);
Freq = (-FreqMax:FreqStep:FreqMax-FreqStep);

sz = size(SIM.Val);
for n = 1:sz(2)
    FT = fftshift(fft(AcqVals(:,n)));
    FT = real(FT);
    FT = 100*FT/max(FT);
    plot(Freq,FT)
end

hFig.Units = 'Inches';
hFig.Position = figarr;

hAx = gca;
hAx.XLim = [-FreqMax FreqMax];
hAx.YLim = ylimvals;
hAx.XLabel.String = 'kHz';
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
