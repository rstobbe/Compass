%======================================================
% 
%======================================================

function [SIM,err] = Simulate_Standard_v1a_Func(SIM,INPUT)

Status2('busy','Standard',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
clear INPUT

%---------------------------------------------
% Simulate
%---------------------------------------------
Simulate(APP,[]);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Simulation',SIM.method,'Output'};
SIM.Panel = Panel;
SIM.PanelOutput = cell2struct(SIM.Panel,{'label','value','type'},2);
  
Status2('done','',2);
Status2('done','',3);