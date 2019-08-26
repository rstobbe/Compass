%====================================================
%
%====================================================

function [RADEV,err] = RSESpiral_manual_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = ['(1./(abs(r.^',RADEV.pval,')*p))']; 

%---------------------------------------------
% Testing
%---------------------------------------------
RADEV.relprojlenmeas = 'Yes';
% pval = str2double(RADEV.pval);
% if pval == 0
%     RADEV.relprojlenmeas = 'Yes';
% else
%     RADEV.relprojlenmeas = 'No';
% end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
