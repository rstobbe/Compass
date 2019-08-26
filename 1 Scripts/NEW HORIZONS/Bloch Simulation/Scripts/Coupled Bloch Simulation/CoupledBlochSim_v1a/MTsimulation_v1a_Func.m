%=========================================================
% 
%=========================================================

function [MTSIM,err] = MTsimulation_v1a_Func(MTSIM,INPUT)

Status('busy','MT Simulation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SEQSIM = INPUT.SEQSIM;
clear INPUT

%---------------------------------------------
% NMR Parameters
%---------------------------------------------
NMRPrms.relM0B = MTSIM.relM0B;
NMRPrms.T1A = MTSIM.T1A;
NMRPrms.T1B = MTSIM.T1B;
NMRPrms.T2A = MTSIM.T2A;
NMRPrms.T2B = MTSIM.T2B;
NMRPrms.ExchgRate = MTSIM.ExchgRate;

%---------------------------------------------
% Sequence Simulation
%---------------------------------------------
func = str2func([MTSIM.seqsimfunc,'_Func']);
INPUT.NMRPrms = NMRPrms;
[SEQSIM,err] = func(SEQSIM,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1000); hold on;
plot(SEQSIM.T,SEQSIM.Marr(:,1),'b');
plot(SEQSIM.T,SEQSIM.Marr(:,2),'c');
ylim([0 1]);

figure(1001); hold on;
plot(SEQSIM.TLast,SEQSIM.MarrLast(:,1),'b');
plot(SEQSIM.TLast,SEQSIM.MarrLast(:,2),'c');
ylim([0 1]);

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'Mxy (atTE)',SEQSIM.Mxy,'Output'};
Panel(2,:) = {'','','Output'};
Panel(3,:) = {'Rel M0B',NMRPrms.relM0B,'Output'};
Panel(4,:) = {'T1A',NMRPrms.T1A,'Output'};
Panel(5,:) = {'T1B',NMRPrms.T1B,'Output'};
Panel(6,:) = {'T2A',NMRPrms.T2A,'Output'};
Panel(7,:) = {'T2B',NMRPrms.T2B,'Output'};
Panel(8,:) = {'ExchangeRate',NMRPrms.ExchgRate,'Output'};
Panel(9,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
MTSIM.PanelOutput = [PanelOutput;SEQSIM.PanelOutput];
MTSIM.SEQSIM = SEQSIM;
