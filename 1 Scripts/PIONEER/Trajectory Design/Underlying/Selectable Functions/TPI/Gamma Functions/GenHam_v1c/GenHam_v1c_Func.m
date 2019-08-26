%====================================================
% 
%====================================================

function [GAMFUNC,err] = GenHam_v1c_Func(GAMFUNC,INPUT)

Status2('busy','Define Gamma Design Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
N = GAMFUNC.N;

%---------------------------------------------
% Define Function
%---------------------------------------------
GAMFUNC.GamFunc = @(r,p) (N+((1/p - N)/(1 - cos(pi*(1+p)))) - ((1/p - N)/(1 - cos(pi*(1+p))))*(cos(pi*(1+r))))/p;

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Filter',GAMFUNC.method,'Output'};
Panel(2,:) = {'N',N,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GAMFUNC.PanelOutput = PanelOutput;
GAMFUNC.Panel = Panel;


Status2('done','',2);
Status2('done','',3);

