%==================================
% 
%==================================

function [RGRS,err] = MonoExp_v1c_Func(RGRS,INPUT)

Status('busy','Mono Exponential Regression');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
clear INPUT;

%-----------------------------------------------------
% Test for B0 Viability
%-----------------------------------------------------
Params = EDDY.TF.Params;
if isfield(Params,'position')                                       % need to add to SMIS
    if strcmp(Params.graddir,Params.position)
        goodB0 = 1;
    else
        goodB0 = 0;
    end
    if strcmp(RGRS.seleddy,'B0eddy') && goodB0 == 0
        err.flag = 1;
        err.msg = 'Experiment not compatible with B0 measurement';
        return
    end
end
    
%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
B0cal = EDDY.B0cal;
Gcal = EDDY.Gcal;
gval = EDDY.gval;
time = EDDY.Time;
eddy = EDDY.(RGRS.seleddy);

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
ind1 = find(time>=RGRS.datastart,1,'first');
ind2 = find(time<=RGRS.datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
RGRS.datastart = time(ind1);
RGRS.datastop = time(ind2);
if strcmp(RGRS.timepastg,'na')
    RGRS.timepastg = 0;
    timeSub = time(ind1:ind2);
    eddySub = eddy(ind1:ind2);
    timePlot = timeSub;
    eddyPlot = eddySub; 
elseif strcmp(RGRS.timepastg,'matchstart')
    RGRS.timepastg = RGRS.datastart;
    timeSub = time(ind1:ind2);
    timeSub = timeSub - timeSub(1) + RGRS.timepastg;
    eddySub = eddy(ind1:ind2);
    timePlot = time(ind1:ind2);
    eddyPlot = eddy(ind1:ind2);
else
    RGRS.timepastg = str2double(RGRS.timepastg);
    timeSub = time(ind1:ind2);
    timeSub = timeSub - timeSub(1) + RGRS.timepastg;
    eddySub = eddy(ind1:ind2);
    timePlot = time(ind1:ind2);
    eddyPlot = eddy(ind1:ind2);
end

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
RGRS.plotalldata = 'Yes';
if timePlot(end) > 5000
    timePlot = timePlot/1000;
    Timelab = '(s)';
else
    Timelab = '(ms)';
end
if strcmp(RGRS.seleddy,'B0eddy')
    YLab = 'B0 Evolution (uT)';
    scale = 1000;
else
    YLab = 'Gradient Evolution (uT/m)';
    scale = 1000;
end
figure(RGRS.figno); hold on;
plot(timePlot,eddyPlot*scale,'b*','linewidth',1);
plot([0 max(timePlot)],[0 0],'k:'); 
ylim([-max(abs(eddy*scale)) max(abs(eddy*scale))]); xlim([0 max(timePlot)]);
xlabel(Timelab); ylabel(YLab);

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.timeSub = timeSub;
RGRS.eddySub = eddySub;

%-----------------------------------------------------
% Regression
%-----------------------------------------------------
ind = find(not(isnan(eddySub)),1,'first');
magest = eddySub(ind);
func = @(P,t) P(1)*exp(-t/P(2)) + RGRS.offset/1000; 
Est = [magest RGRS.tcest];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(timeSub,eddySub,func,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)
RGRS.beta = beta;
RGRS.ci = ci;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end

PlotStop = 20000;

%RGRS.interptime = (0:step:timeSub(length(timeSub)));
RGRS.interptime = (0:step:PlotStop);
RGRS.interpvals = func(beta,RGRS.interptime);
RGRS.interptime = RGRS.interptime + RGRS.datastart - RGRS.timepastg;

if RGRS.interptime(end) > 5000
    timePlot = RGRS.interptime/1000;
end
figure(RGRS.figno); hold on;
plot(timePlot,RGRS.interpvals*scale,'r-','linewidth',2);
ylim([-max(abs(RGRS.interpvals*scale)) max(abs(RGRS.interpvals*scale))]); xlim([0 max(timePlot)]);
plot([0 PlotStop],[0 0],'k:'); 

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Tc (ms)',beta(2),'Output'};
if strcmp(RGRS.seleddy,'B0eddy') 
    Panel(2,:) = {'Mag (uT)',beta(1)*scale,'Output'};
    RGRS.CompVpcnt = beta(1)*scale/(B0cal*gval);
    Panel(3,:) = {'CompVal (%)',beta(1)*scale/(B0cal*gval),'Output'};
else
    Panel(2,:) = {'Mag (uT/m)',beta(1)*scale,'Output'};
    RGRS.CompPcnt = -100*beta(1)/gval;
    RGRS.CompVpcnt = -100*Gcal*beta(1)/gval;
    Panel(3,:) = {'CompPcnt (%)',-100*beta(1)/gval,'Output'};  
    Panel(4,:) = {'CompSysPcnt (%)',-100*Gcal*beta(1)/gval,'Output'};    
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

