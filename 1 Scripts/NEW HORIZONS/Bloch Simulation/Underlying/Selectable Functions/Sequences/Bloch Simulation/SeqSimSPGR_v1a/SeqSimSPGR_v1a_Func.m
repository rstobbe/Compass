%=========================================================
% 
%=========================================================

function [SPGR,err] = SeqSimSPGR_v1a_Func(SPGR,INPUT)

Status2('busy','Simulate SPGR sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
NMRPrms = INPUT.NMRPrms;
SIM = SPGR.SIM;
clear INPUT

%---------------------------------------------
% Seq Parameters
%---------------------------------------------
SPGR.w1 = (pi*SPGR.flip/180)/SPGR.tau;

%---------------------------------------------
% Set up
%---------------------------------------------
M0 = [1 0 0];
INPUT.T1 = NMRPrms.T1;
INPUT.T2 = NMRPrms.T2;
INPUT.w1 = [SPGR.w1 SPGR.w1];
INPUT.time = [0 SPGR.tau];
INPUT.woff = [SPGR.woff SPGR.woff];
INPUT.phase = pi*SPGR.rfspoil/180;
simfunc = str2func([SPGR.simfunc,'_DE']);

%---------------------------------------------
% Sim Parameters
%---------------------------------------------
t = linspace(0,SPGR.tau,10);

%---------------------------------------------
% Set up
%---------------------------------------------
func = @(t,M) simfunc(t,M,SIM,INPUT);
[t,M] = ode45(func,t,M0);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'Excitation Flip',SeqPrms.exrffa,'Output'};
Panel(2,:) = {'Excitation Off-Res',SeqPrms.exrfwoff,'Output'};
Panel(3,:) = {'Excitation Pulse-Len',SeqPrms.exrftau,'Output'};
Panel(4,:) = {'TR',SeqPrms.TR,'Output'};
Panel(5,:) = {'NSteady',SeqPrms.NSteady,'Output'};
Panel(6,:) = {'TE',SeqPrms.TE,'Output'};
SPGR.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

