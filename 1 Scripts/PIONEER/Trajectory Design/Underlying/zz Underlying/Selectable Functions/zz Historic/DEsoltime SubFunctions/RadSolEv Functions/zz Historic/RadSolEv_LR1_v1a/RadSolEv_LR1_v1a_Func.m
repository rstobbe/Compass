%====================================================
%
%====================================================

function [RADEV,err] = RadSolEv_LR1_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsoloutfunc = '(1/p^2)';
if strcmp(TST.relprojlenmeas,'Yes')
    RADEV.deradsolinfunc = '(1/p^2)';
else
    RADEV.deradsolinfunc = '(1./(abs((r/p).^1.5)*p^2))';
end

%---------------------------------------------
% Define tolerance for diffeq solver
%---------------------------------------------
RADEV.outtol = 1e-13;
if strcmp(TST.relprojlenmeas,'Yes')
    RADEV.intol = 1e-6;
else
    RADEV.intol = 1e-12;
end

%---------------------------------------------
% Solution Timing
%---------------------------------------------
RADEV.D = 200000;                 % probably need cases added
RADEV.Tstart = 1.05*(1/RADEV.D);

%---------------------------------------------
% Testing
%--------------------------------------------- 
RADEV.relprojlenmeas = TST.relprojlenmeas;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
