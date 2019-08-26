%==================================
% 
%==================================

function [RGRS,err] = ShortEddyModelFitting_v1a_Func(RGRS,INPUT)

Status('busy','Regress Short Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
GRD = INPUT.GRD;
ECM = RGRS.ECM;
clear INPUT;

%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
L = GRD.L;
Gvis = GRD.Gvis;
Gdes = GRD.G(:,3);
Tdes = GRD.T;
Time = EDDY.Time;
Gmeas = EDDY.Geddy;
gstepdur = GRD.gstepdur/1000;
if isfield(GRD,'initfinaldecay')
    initfinaldecay = GRD.initfinaldecay;
else
    initfinaldecay = 10.8475;                   % for BPGradUSL1 (its old)
end

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
Time = Time + RGRS.gstartshift/1000;

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5000); hold on;
    plot([0 max(L)],[0 0],'k:');     
    plot(L,Gvis,'k-');
    plot(Time,Gmeas,'r-');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
    xlim([0 Time(length(Time))]);
end

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
TdesStop = Tdes(length(Tdes)); 
Tdes = [Tdes (TdesStop+gstepdur:gstepdur:TdesStop+1.00)];
Gdes = [Gdes;zeros(length(Tdes)-length(Gdes),1)];
ind1 = find(round(Tdes*1e4) == round((initfinaldecay-gstepdur)*1e4),1,'last');
ind2 = find(Tdes <= initfinaldecay+0.5,1,'last');
GdesSub = Gdes(ind1:ind2);
TdesSub = Tdes(ind1:ind2);
eddySub = interp1(Time,Gmeas,TdesSub,'linear','extrap');
TimeSub = TdesSub - (initfinaldecay-gstepdur); 

%-----------------------------------------------------
% Traj Vis
%-----------------------------------------------------
GvisSub = []; LSub = [];
for n = 1:length(TdesSub)-1
    LSub = [LSub [TimeSub(n) TimeSub(n+1)]];
    GvisSub = [GvisSub [GdesSub(n) GdesSub(n)]];
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5001); hold on;
    plot([0 max(L)],[0 0],'k:');     
    plot(LSub,GvisSub,'k-');
    plot(TimeSub,eddySub,'r-');
    xlim([TimeSub(1) 0.5]);
    ylim([-max(abs(Gmeas)) 0.2*max(abs(Gmeas))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Measured Gradient Field ');
end

%-----------------------------------------------------
% Isolate Regress Data
%-----------------------------------------------------
ind = find(round(TimeSub*1e6) >= round(RGRS.rgrsstart*1e6),1,'first');
ind2 = length(TimeSub);
TimeSub = TimeSub(ind:ind2);
eddySub = eddySub(ind:ind2);
GdesSub = GdesSub(ind:ind2);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5001); hold on;
    plot(TimeSub,eddySub,'b-');
end

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.Time = TimeSub;
RGRS.Gmeas = eddySub;
RGRS.Gdes = GdesSub;

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
Status2('busy','Perform Regression',2);
func = str2func([RGRS.modelfunc,'_Func']);
INPUT.Time = TimeSub;
INPUT.Gmeas = eddySub;
INPUT.Tdes = TimeSub;
INPUT.Gdes = GdesSub;
INPUT.gstepdur = gstepdur;
INPUT.L = LSub;
INPUT.Gvis = GvisSub;
[ECM,err] = func(ECM,INPUT);
if err.flag
    return
end

RGRS.PanelOutput = ECM.PanelOutput;

Status2('done','',2);
Status2('done','',3);
