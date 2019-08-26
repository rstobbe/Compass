%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_IdealLR_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsoloutfunc = '(1/p^2)';
RADEV.deradsolinfunc = '(1/p^2)';

%---------------------------------------------
% Solution Tolerences
%---------------------------------------------
RADEV.intol = 5e-7;        
RADEV.outtol = 5e-14;  

%---------------------------------------------
% Return
%--------------------------------------------- 
RADEV.relprojlenmeas = TST.relprojlenmeas;
RADEV.PanelOutput = struct();

Status2('done','',3);
