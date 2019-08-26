%===========================================
% 
%===========================================

function [RLX,err] = SigDec_BrainMod1_v1a_Func(RLX,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
clear INPUT

RLX.T2f1 = 1;
RLX.T2f2 = 2.5;
RLX.T2s = 25;
RLX.TE = 0.15;

%---------------------------------------------
% Create Function
%---------------------------------------------
RLX.func = @(t) (0.25*exp(-(t+RLX.TE)/RLX.T2f1)+0.35*exp(-(t+RLX.TE)/RLX.T2f2)+0.4*exp(-(t+RLX.TE)/RLX.T2s))/...
                (0.25*exp(-RLX.TE/RLX.T2f1)+0.35*exp(-RLX.TE/RLX.T2f2)+0.4*exp(-RLX.TE/RLX.T2s));

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',RLX.method,'Output'};
Panel(3,:) = {'T2f_1 (25%)',RLX.T2f1,'Output'};
Panel(4,:) = {'T2f_2 (35%)',RLX.T2f2,'Output'};
Panel(5,:) = {'T2s (40%)',RLX.T2s,'Output'};
Panel(6,:) = {'TE',RLX.TE,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

RLX.Panel = Panel;
RLX.PanelOutput = PanelOutput;