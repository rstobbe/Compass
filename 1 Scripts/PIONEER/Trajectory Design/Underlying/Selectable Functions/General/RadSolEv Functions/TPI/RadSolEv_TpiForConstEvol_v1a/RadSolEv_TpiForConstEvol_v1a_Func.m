%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_TpiForConstEvol_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solution',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsoloutfunc = '1';
RADEV.deradsolinfunc = '1';

%---------------------------------------------
% Solution Tolerences
%--------------------------------------------- 
%RADEV.outtol = 5e-8;  
RADEV.outtol = 2e-8;  

%---------------------------------------------
% Other
%---------------------------------------------
RADEV.relprojlenmeas = 'No';
RADEV.constevol = 'Yes';

Status2('done','',3);
