%===========================================
% 
%===========================================

function [RLX,err] = SigDec_ArbBiex_v1a_Func(RLX,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Create Function
%---------------------------------------------
RLX.func = @(t) (RLX.pT2f*exp(-(t+RLX.TE)/RLX.T2f)+RLX.pT2s*exp(-(t+RLX.TE)/RLX.T2s))/(RLX.pT2f*exp(-RLX.TE/RLX.T2f)+RLX.pT2s*exp(-RLX.TE/RLX.T2s));

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',RLX.method,'Output'};
Panel(3,:) = {'T2f',RLX.T2f,'Output'};
Panel(4,:) = {'T2f (%)',RLX.pT2f,'Output'};
Panel(5,:) = {'T2s',RLX.T2s,'Output'};
Panel(6,:) = {'T2s (%)',RLX.pT2s,'Output'};
Panel(7,:) = {'TE',RLX.TE,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

RLX.Panel = Panel;
RLX.PanelOutput = PanelOutput;