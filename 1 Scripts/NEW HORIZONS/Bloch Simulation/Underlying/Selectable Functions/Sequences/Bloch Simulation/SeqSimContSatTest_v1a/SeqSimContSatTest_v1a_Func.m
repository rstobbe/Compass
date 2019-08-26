%=========================================================
% 
%=========================================================

function [CSAT,err] = SeqSimContSatTest_v1a_Func(CSAT,INPUT)

Status2('busy','Simulate Continuous Saturation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
NMRPrms = INPUT.NMRPrms;
SIM = CSAT.SIM;
clear INPUT

%---------------------------------------------
% Seq Parameters
%---------------------------------------------
CSAT.w1 = (pi*CSAT.rffa/180)/CSAT.rftau;

%---------------------------------------------
% Set up
%---------------------------------------------
M0 = [1 0 0];
INPUT.T1 = NMRPrms.T1;
INPUT.T2 = NMRPrms.T2;
INPUT.w1 = [CSAT.w1 CSAT.w1];
INPUT.time = [0 CSAT.rftau];
INPUT.woff = CSAT.rfwoff;
simfunc = str2func([CSAT.simfunc,'_DE']);

%---------------------------------------------
% Sim Parameters
%---------------------------------------------
t = linspace(0,CSAT.rftau,1000);

%---------------------------------------------
% Set up
%---------------------------------------------
func = @(t,M) simfunc(t,M,SIM,INPUT);
[t,M] = ode45(func,t,M0);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); hold on;
plot(t,M);


%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'Excitation Flip',SeqPrms.exrffa,'Output'};
Panel(2,:) = {'Excitation Off-Res',SeqPrms.exrfwoff,'Output'};
Panel(3,:) = {'Excitation Pulse-Len',SeqPrms.exrftau,'Output'};
Panel(4,:) = {'TR',SeqPrms.TR,'Output'};
Panel(5,:) = {'NSteady',SeqPrms.NSteady,'Output'};
Panel(6,:) = {'TE',SeqPrms.TE,'Output'};
CSAT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

