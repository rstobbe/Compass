%===========================================
% 
%===========================================

function [RLX,err] = SigDec_NaBiex_v1b_Func(RLX,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Create Function
%---------------------------------------------
RLX.func = @(t) (0.6*exp(-(t+RLX.TE)/RLX.T2f)+0.4*exp(-(t+RLX.TE)/RLX.T2s))/(0.6*exp(-RLX.TE/RLX.T2f)+0.4*exp(-RLX.TE/RLX.T2s));

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',RLX.method,'Output'};
Panel(3,:) = {'T2f',RLX.T2f,'Output'};
Panel(4,:) = {'T2s',RLX.T2s,'Output'};
Panel(5,:) = {'TE',RLX.TE,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

RLX.Panel = Panel;
RLX.PanelOutput = PanelOutput;