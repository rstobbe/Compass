%==================================
% 
%==================================

function [RGRS,err] = GenModelFitting_v1a_Func(RGRS,INPUT)

Status('busy','General Model Fitting');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
GRD = RGRS.GRD;
clear INPUT;

%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
L = GRD.L;
Gvis = GRD.Gvis;
Gdes = GRD.G(:,3);
Tdes = GRD.T;
time = EDDY.Time;
eddy = EDDY.Geddy;
gstepdur = GRD.gstepdur/1000;
if isfield(GRD,'initfinaldecay')
    initfinaldecay = GRD.initfinaldecay;
else
    initfinaldecay = 10.8475;
end

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
figure(5000); hold on;
plot(L,Gvis,'b-');
plot(Tdes + gstepdur/2,Gdes,'r-');    % put in middle of step for visual
plot(time,eddy,'k-');
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
TdesStop = Tdes(length(Tdes)); 
Tdes = [Tdes (TdesStop+gstepdur:gstepdur:TdesStop+0.6)];
Gdes = [Gdes;zeros(length(Tdes)-length(Gdes),1)];
ind1 = find(round(Tdes*1e4) == round((initfinaldecay-gstepdur)*1e4),1,'last');
ind2 = find(Tdes <= initfinaldecay+0.5,1,'last');
GdesSub = Gdes(ind1:ind2);
TdesSub = Tdes(ind1:ind2);
eddySub = interp1(time,eddy,TdesSub,'linear','extrap');
TimeSub = TdesSub - (initfinaldecay-gstepdur); 

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
figure(5001); hold on;
plot(TimeSub,eddySub,'k');
plot(TimeSub,GdesSub,'r*');
plot([0 TimeSub(length(TimeSub))],[0 0],'k:'); 
xlim([TimeSub(1) 0.5]);
ylim([-max(abs(eddy)) 0.2*max(abs(eddy))]);

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.TimeSub = TimeSub;
RGRS.eddySub = eddySub;
RGRS.GdesSub = GdesSub;

%-----------------------------------------------------
% Regress
%-----------------------------------------------------
Resp = zeros(length(GdesSub),1);
Resp(2) = GdesSub(2) - eddySub(2);
for n = 3:length(GdesSub)
    Resp(n) = (GdesSub(n) - eddySub(n)) - sum(Resp(1:n));
end

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
figure(5002); hold on;
plot(TimeSub(2:length(Resp)),-Resp(2:length(Resp)),'k');

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;



