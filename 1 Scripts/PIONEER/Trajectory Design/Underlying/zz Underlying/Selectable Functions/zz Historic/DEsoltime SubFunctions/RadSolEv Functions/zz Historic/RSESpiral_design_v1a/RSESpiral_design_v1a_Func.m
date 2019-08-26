%====================================================
%
%====================================================

function [RADEV,err] = RSESpiral_design_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = '(1/p)';
%PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Define tolerance for diffeq solver
%---------------------------------------------
RADEV.intol = 1e-6;
RADEV.outtol = 1e-7;
RADEV.solintol = 1e-7;
RADEV.solouttol = 1e-8;
RADEV.D = 3900;
RADEV.solinlenfact = 3.5;

RADEV.relprojlenmeas = 'Yes';

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
