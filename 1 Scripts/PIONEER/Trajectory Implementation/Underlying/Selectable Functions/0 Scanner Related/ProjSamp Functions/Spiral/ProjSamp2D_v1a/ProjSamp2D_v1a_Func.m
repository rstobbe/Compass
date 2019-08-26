%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp2D_v1a_Func(PSMP,INPUT) 

Status2('busy','Calculate Projection Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJdgn.nproj;

%-----------------------------------------------
% Calculate Projection Distributions
%-----------------------------------------------
theta_step = pi/nproj;                                                              
theta = (pi-theta_step/2:-theta_step:0);
PSMP.theta = theta;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'nproj',num2str(nproj),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);








