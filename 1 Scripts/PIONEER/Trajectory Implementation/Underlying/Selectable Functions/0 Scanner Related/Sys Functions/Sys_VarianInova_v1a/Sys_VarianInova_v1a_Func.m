%====================================================
% 
%====================================================

function [SYS,err] = Sys_VarianInova_v1a_Func(SYS,INPUT)

Status2('busy','Return System Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%----------------------------------------------------
% Specify
%----------------------------------------------------
SYS.System = 'VarianInova';

%----------------------------------------------------
% Sampling Limits
%----------------------------------------------------
SYS.MaxSW = 500000;
SYS.MaxFB = 256000;
SYS.SampBase = 12.5;
SYS.RelSamp2Filt = 1.2;
SYS.PhysMatRelation = 'LRTBIO';     % X-Y-Z

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'System','VarianInova','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
