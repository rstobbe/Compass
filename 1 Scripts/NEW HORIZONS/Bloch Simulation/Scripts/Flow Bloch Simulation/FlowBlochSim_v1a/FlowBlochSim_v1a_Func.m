%=========================================================
% 
%=========================================================

function [BLSIM,err] = FlowBlochSim_v1a_Func(BLSIM,INPUT)

Status('busy','Flow Bloch Simulation');
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
NMRPrms.T1 = BLSIM.T1;
NMRPrms.T2 = BLSIM.T2;
NMRPrms.vel = BLSIM.vel;

%---------------------------------------------
% Sequence Simulation
%---------------------------------------------
func = str2func([BLSIM.seqsimfunc,'_Func']);
INPUT.NMRPrms = NMRPrms;
[SEQSIM,err] = func(SEQSIM,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'T1 (ms)',NMRPrms.T1,'Output'};
Panel(2,:) = {'T2 (ms)',NMRPrms.T2,'Output'};
Panel(3,:) = {'Flow Rate (m/s)',NMRPrms.vel,'Output'};
Panel(4,:) = {'','','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
BLSIM.PanelOutput = [PanelOutput;SEQSIM.PanelOutput];
BLSIM.SEQSIM = SEQSIM;
