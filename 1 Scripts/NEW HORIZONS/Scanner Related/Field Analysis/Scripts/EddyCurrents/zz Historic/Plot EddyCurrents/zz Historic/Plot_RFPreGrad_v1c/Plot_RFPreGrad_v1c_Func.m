%==================================================
% 
%==================================================

function [PLOT,err] = Plot_RFPreGrad_v1c_Func(PLOT,INPUT)

Status('busy','Plot Transient Fields During/After Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
GRD = INPUT.GRD;
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
    initfinaldecay = 10.8475;                   % for BPGradUSL1 (its old)
end

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
time = time + PLOT.gstartshift/1000;

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
figure(5000); hold on;
plot([0 max(time)],[0 0],'k:'); 
plot(L,Gvis,'k-');
plot(time,eddy,[PLOT.clr,'-']);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Measured Gradient Field ');
xlim([0 time(length(time))]);

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
eddySub = interp1(time,eddy,TdesSub,'linear','extrap');
TimeSub = TdesSub - (initfinaldecay-gstepdur); 

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(5001); hold on;
plot([0 TimeSub(length(TimeSub))],[0 0],'k:'); 
plot(TimeSub,GdesSub,'k*');
plot(TimeSub,eddySub,[PLOT.clr,'*']);
xlim([TimeSub(1) 0.5]);
ylim([-max(abs(eddy)) 0.2*max(abs(eddy))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Measured Gradient Field ');

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
%figure(5002); hold on; 
%plot([0 max(time)],[0 0],'k:'); 
%plot(time,B0eddy*1000,clr);
%plot(L,-10*Gvis/max(Gvis),'b-');
%plot(L,10*Gvis/max(Gvis),'b-');
%ylim([-1 1]);
%xlabel('(ms)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;

%===============================================
function OutStyle
outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
end