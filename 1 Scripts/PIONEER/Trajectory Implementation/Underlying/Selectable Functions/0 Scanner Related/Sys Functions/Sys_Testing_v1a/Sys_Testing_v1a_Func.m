%====================================================
% 
%====================================================

function [SYS,err] = Sys_Testing_v1a_Func(SYS,INPUT)

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
SYS.System = 'Testing';

%----------------------------------------------------
% ADC 
%----------------------------------------------------
SYS.MinDwell = 1000;                % in ns
SYS.SampBase = 25;                  % in ns
SYS.SampDel = 0;

%----------------------------------------------------
% Gradient 
%----------------------------------------------------
SYS.GradSampBase = 1;               % in us        
SYS.MaxSlew = 200;                  % in mT/m/ms 
SYS.MinGradDel = 0.055;
SYS.AcousticFreqsCen = [590 1140];
SYS.AcousticFreqsHBW = [50 100];
SYS.PhysMatRelation = 'LRTBIO';     % X-Y-Z

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
Panel(1,:) = {'System','Testing','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SYS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

