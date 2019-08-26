%===========================================
% 
%===========================================

function [RLX,err] = SigDec_Mono_v1b_Func(RLX,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Create Function
%---------------------------------------------
RLX.func = @(t) exp(-t/RLX.T2);

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',RLX.method,'Output'};
Panel(3,:) = {'T2',RLX.T2,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

RLX.Panel = Panel;
RLX.PanelOutput = PanelOutput;