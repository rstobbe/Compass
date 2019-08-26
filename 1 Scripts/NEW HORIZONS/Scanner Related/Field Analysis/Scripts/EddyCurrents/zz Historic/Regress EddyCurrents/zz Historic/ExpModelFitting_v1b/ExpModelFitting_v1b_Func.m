%==================================
% 
%==================================

function [RGRS,err] = ExpModelFitting_v1b_Func(RGRS,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.EDDY;
ECM = INPUT.ECM;
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
tcest = RGRS.tcest;
magest = RGRS.magest; 
gstepdur = GRD.gstepdur/1000;
if isfield(GRD,'initfinaldecay')
    initfinaldecay = GRD.initfinaldecay;
else
    initfinaldecay = 10.8475;                   % for BPGradUSL1 (its old)
end

%-----------------------------------------------------
% TDes to middle
%-----------------------------------------------------
Tdes = Tdes + gstepdur/2;
initfinaldecay = initfinaldecay + gstepdur/2;

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
time = time + RGRS.gstartshift/1000;

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
doplot = 1;
if doplot == 1
    figure(5000); hold on;
    plot(L,Gvis,'b-');
    plot(Tdes,Gdes,'r-');    % put in middle of step for visual
    plot(time,eddy,'k-');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
end

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
doplot = 1;
if doplot == 1
    figure(5001); hold on;
    plot(TimeSub,eddySub,'k*');
    plot(TimeSub,GdesSub,'r*');
    plot([0 TimeSub(length(TimeSub))],[0 0],'k:'); 
    xlim([TimeSub(1) 0.5]);
    ylim([-max(abs(eddy)) 0.2*max(abs(eddy))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)');
end

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.Time = TimeSub;
RGRS.Gmeas = eddySub;
RGRS.Gdes = GdesSub;

%-----------------------------------------------------
% Regression Setup
%-----------------------------------------------------
regfunc = str2func([RGRS.modelfunc,'_Reg']);
options = optimset( 'Algorithm','levenberg-marquardt',...           % levenberg-marquardt (trust-region-reflective)
                    'Diagnostics','on',...                    
                    'DiffMinChange',1e-2,...                        % 
                    'Display','iter',...
                    'FinDiffType','forward',...                     % forward (central)    
                    'TolFun',1e-3);                                 % measure relative change in least-squares
lb = [];                                                            % not used for 'levenberg-marquardt'               
ub = [];

%-----------------------------------------------------
% Scale
%-----------------------------------------------------
scale = 10000;

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
INPUT.scale = scale;
INPUT.Time = TimeSub;
INPUT.Gmeas = eddySub;
INPUT.Gdes = GdesSub;
INPUT.gstepdur = gstepdur;
func = @(V)regfunc(V,ECM,INPUT);

%-----------------------------------------------------
% Initial Estimates
%-----------------------------------------------------
if length(tcest) == 1
    V0(1) = tcest*scale;
    V0(2) = magest;
elseif length(tcest) == 2
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
elseif length(tcest) == 3
    V0(1) = tcest(1)*scale;
    V0(2) = magest(1);
    V0(3) = tcest(2)*scale;
    V0(4) = magest(2);
    V0(5) = tcest(3)*scale;
    V0(6) = magest(3);    
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
if length(tcest) == 1
    RGRS.tc = V(1)/scale;
    RGRS.mag = V(2);
    Panel(1,:) = {'Tc (ms)',RGRS.tc,'Output'};
    Panel(2,:) = {'Mag (%)',RGRS.mag,'Output'};    
elseif length(tcest) == 2
    RGRS.tc1 = V(1)/scale;
    RGRS.mag1 = V(2);
    RGRS.tc2 = V(3)/scale;
    RGRS.mag2 = V(4);
    Panel(1,:) = {'Tc1 (ms)',RGRS.tc1,'Output'};
    Panel(2,:) = {'Mag1 (%)',RGRS.mag1,'Output'};    
    Panel(3,:) = {'Tc2 (ms)',RGRS.tc2,'Output'};
    Panel(4,:) = {'Mag2 (%)',RGRS.mag2,'Output'};    
elseif length(tcest) == 3
    RGRS.tc1 = V(1)/scale;
    RGRS.mag1 = V(2);
    RGRS.tc2 = V(3)/scale;
    RGRS.mag2 = V(4);
    RGRS.tc3 = V(5)/scale;
    RGRS.mag3 = V(6);
    Panel(1,:) = {'Tc1 (ms)',RGRS.tc1,'Output'};
    Panel(2,:) = {'Mag1 (%)',RGRS.mag1,'Output'};    
    Panel(3,:) = {'Tc2 (ms)',RGRS.tc2,'Output'};
    Panel(4,:) = {'Mag2 (%)',RGRS.mag2,'Output'};   
    Panel(5,:) = {'Tc3 (ms)',RGRS.tc3,'Output'};
    Panel(6,:) = {'Mag3 (%)',RGRS.mag3,'Output'};   
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;



