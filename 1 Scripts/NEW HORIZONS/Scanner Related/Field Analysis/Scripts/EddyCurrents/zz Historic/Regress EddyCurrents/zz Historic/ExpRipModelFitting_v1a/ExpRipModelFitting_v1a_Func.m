%==================================
% 
%==================================

function [RGRS,err] = ExpRipModelFitting_v1a_Func(RGRS,INPUT)

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
sincfreqest = RGRS.sincfreqest;
sinctcest = RGRS.sinctcest;
sincmagest = RGRS.sincmagest;
gstepdur = GRD.gstepdur/1000;
if isfield(GRD,'initfinaldecay')
    initfinaldecay = GRD.initfinaldecay;
else
    initfinaldecay = 10.8475;
end

%-----------------------------------------------------
% Plot Gradient Design
%-----------------------------------------------------
doplot = 0;
if doplot == 1
    figure(5000); hold on;
    plot(L,Gvis,'b-');
    plot(Tdes + gstepdur/2,Gdes,'r-');    % put in middle of step for visual
    plot(time,eddy,'k-');
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');
end

%-----------------------------------------------------
% Gradient Time Shift
%-----------------------------------------------------
time = time + RGRS.gstartshift/1000;

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
doplot = 0;
if doplot == 1
    figure(5001); hold on;
    plot(TimeSub,eddySub,'k');
    plot(TimeSub,GdesSub,'r*');
    plot([0 TimeSub(length(TimeSub))],[0 0],'k:'); 
    xlim([TimeSub(1) 0.5]);
    ylim([-max(abs(eddy)) 0.2*max(abs(eddy))]);
end

%-----------------------------------------------------
% Save
%-----------------------------------------------------
RGRS.TimeSub = TimeSub;
RGRS.eddySub = eddySub;
RGRS.GdesSub = GdesSub;

%-----------------------------------------------------
% Regression Setup
%-----------------------------------------------------
regfunc = str2func([RGRS.modelfunc,'_Reg']);
options = optimset( 'Algorithm','trust-region-reflective',...       % trust-region-reflective (levenberg-marquardt)
                    'Diagnostics','on',...                    
                    'DiffMinChange',1e-3,...                        % 
                    'Display','iter',...
                    'FinDiffType','forward',...                     % forward (central)    
                    'TolFun',1e-6,...
                    'TolX',1e-3);
lb = [];                                                            % not used for 'levenberg-marquardt'               
ub = [];

%-----------------------------------------------------
% Regression Function Input
%-----------------------------------------------------
INPUT.TimeSub = TimeSub;
INPUT.eddySub = eddySub;
INPUT.GdesSub = GdesSub;
INPUT.gstepdur = gstepdur;
func = @(V)regfunc(V,ECM,INPUT);

%-----------------------------------------------------
% Initial Estimates
%-----------------------------------------------------
if length(tcest) == 1
    V0(1) = tcest;
    V0(2) = magest/1000;
    V0(3) = sincfreqest/1000;
    V0(4) = sinctcest;
    V0(5) = sincmagest/1000;   
elseif length(tcest) == 2
    V0(1) = tcest(1);
    V0(2) = magest(1)/1000;
    V0(3) = tcest(2);
    V0(4) = magest(2)/1000;
    V0(5) = sincfreqest/1000;
    V0(6) = sinctcest;
    V0(7) = sincmagest/1000;       
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0,lb,ub,options);
if length(tcest) == 1
    RGRS.tc = V(1);
    RGRS.mag = V(2)*1000;
    Panel(1,:) = {'Tc (ms)',RGRS.tc,'Output'};
    Panel(2,:) = {'Mag (%)',RGRS.mag,'Output'};    
elseif length(tcest) == 2
    RGRS.sincfreq = V(5)*1000;
    RGRS.sinctc = V(6);
    RGRS.sincmag = V(7)*1000;
    RGRS.mag2 = V(4)*1000;
    RGRS.tc1 = V(1);
    RGRS.mag1 = V(2)*1000;
    RGRS.tc2 = V(3);
    RGRS.mag2 = V(4)*1000;
    Panel(1,:) = {'SincFreq (kHz)',RGRS.sincfreq,'Output'};
    Panel(2,:) = {'SincTc (ms)',RGRS.sinctc,'Output'}; 
    Panel(3,:) = {'SincMag (%)',RGRS.sincmag,'Output'}; 
    Panel(4,:) = {'Tc1 (ms)',RGRS.tc1,'Output'};
    Panel(5,:) = {'Mag1 (%)',RGRS.mag1,'Output'};    
    Panel(6,:) = {'Tc2 (ms)',RGRS.tc2,'Output'};
    Panel(7,:) = {'Mag2 (%)',RGRS.mag2,'Output'};    
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
RGRS.PanelOutput = PanelOutput;



