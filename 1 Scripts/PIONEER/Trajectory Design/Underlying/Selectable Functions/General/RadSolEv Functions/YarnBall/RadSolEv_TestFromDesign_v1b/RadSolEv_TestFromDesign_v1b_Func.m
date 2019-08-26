%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_ForConstEvol_v1b_Func(RADEV,INPUT)

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
%RADEV.deradsolinfunc = '1./(abs((r/p).^2.5))';
RADEV.deradsolinfunc = '1';

%---------------------------------------------
% Solution Tolerences
%---------------------------------------------  
RADEV.outtol = 5e-14;  

%---------------------------------------------
% Other
%---------------------------------------------
RADEV.relprojlenmeas = 'No';
RADEV.constevol = 'Yes';

Status2('done','',3);
