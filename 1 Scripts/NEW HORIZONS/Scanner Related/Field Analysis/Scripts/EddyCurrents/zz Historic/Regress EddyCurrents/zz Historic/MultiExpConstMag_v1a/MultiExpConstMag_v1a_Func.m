%==================================
% 
%==================================

function [RGRS,err] = MultiExpConstMag_v1a_Func(RGRS,INPUT)

Status('busy','Regress Eddy Currents');
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
if strcmp(RGRS.timepastg,'na')
    RGRS.timepastg = 0;
    timeSub = time(ind1:ind2);
    eddySub = eddy(ind1:ind2);
    timePlot = timeSub;
    eddyPlot = eddySub; 
    scale = 1000;
else
    RGRS.timepastg = str2double(RGRS.timepastg);
    timeSub = time(ind1:ind2);
    timeSub = timeSub - timeSub(1) + RGRS.timepastg;
    eddySub = eddy(ind1:ind2);
    timePlot = time(ind1:ind2);
    eddyPlot = eddy(ind1:ind2);
    scale = 1;
end

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
figure(RGRS.figno); hold on;
plot(timePlot,eddyPlot*scale,'k');
plot([0 max(time)],[0 0],'k:'); 
ylim([-max(abs(eddy*scale)) max(abs(eddy*scale))]);

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.timeSub = timeSub;
RGRS.eddySub = eddySub;

%-----------------------------------------------------
% Regression Functions
%-----------------------------------------------------
val = RGRS.cmag*gval/(100*Gcal);
%***
%P0 = [0.8 RGRS.tcest/2 RGRS.tcest*2];
%eddySub = 2*val*(P0(1)*exp(-timeSub/P0(2))+(1-P0(1))*exp(-timeSub/P0(3)));
%***
if RGRS.nexps == 1
    func = @(P,t) val*exp(-t/P(1)); 
    Est = [RGRS.tcest];
    %func = @(P,t) P(1)*exp(-t/P(2)); 
    %Est = [0.5 RGRS.tcest];
elseif RGRS.nexps == 2
    func = @(P,t) val*(P(1)*exp(-t/P(2))+(1-P(1))*exp(-t/P(3)));
    Est = [0.5 RGRS.tcest/3 RGRS.tcest*3];
    %func = @(P,t) val*(P(1)*exp(-t/P(2))+P(3)*exp(-t/P(4)));
    %Est = [0.5 0.5 RGRS.tcest/2 RGRS.tcest*2];
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
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
RGRS.interptime = (0:step:timeSub(length(timeSub)));
RGRS.interpvals = func(beta,RGRS.interptime);
RGRS.interptime = RGRS.interptime + RGRS.datastart - RGRS.timepastg;

clr = 'r';
figure(RGRS.figno); hold on;
plot(RGRS.interptime,RGRS.interpvals*scale,[clr,'-'],'linewidth',2);
%plot(time,eddy*scale,'k*');

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
if strcmp(RGRS.seleddy,'B0eddy') 
    Panel(2,:) = {'Mag (uT)',beta(1)*scale,'Output'};
    RGRS.CompVpcnt = beta(1)*scale/(B0cal*gval);
    Panel(3,:) = {'CompVal (%)',beta(1)*scale/(B0cal*gval),'Output'};
else
    if RGRS.nexps == 1
        Panel(1,:) = {'Tc (ms)',beta(1),'Output'};
        Panel(2,:) = {'Mag (mT/m)',val*scale,'Output'};
        RGRS.CompVpcnt = -100*Gcal*val/gval;
        Panel(3,:) = {'CompVal (%)',-100*Gcal*val/gval,'Output'};
    elseif RGRS.nexps == 2
    end
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;



