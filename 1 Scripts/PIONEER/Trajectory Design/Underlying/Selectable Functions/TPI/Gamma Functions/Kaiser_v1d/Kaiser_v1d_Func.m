%====================================================
% 
%====================================================

function [GAMFUNC,err] = Kaiser_v1d_Func(GAMFUNC,INPUT)

Status2('busy','Define Gamma Design Function',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
beta = GAMFUNC.beta;

%---------------------------------------------
% Define Function
%---------------------------------------------
GAMFUNC.GamFunc = @(r,p) (1/p^2)*besseli(0,beta * sqrt(1 - r.^2))/besseli(0,beta * sqrt(1 - p.^2));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'beta',beta,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GAMFUNC.PanelOutput = PanelOutput;
GAMFUNC.Panel = Panel;




