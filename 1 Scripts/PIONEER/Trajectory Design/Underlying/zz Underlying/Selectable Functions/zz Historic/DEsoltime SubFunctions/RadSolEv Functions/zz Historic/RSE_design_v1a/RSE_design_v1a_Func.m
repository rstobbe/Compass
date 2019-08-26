%====================================================
%
%====================================================

function [RADEV,err] = RSE_design_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = '(1/p^2)';
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Define tolerance for diffeq solver
%---------------------------------------------
RADEV.intol = 1e-6;
RADEV.outtol = 1e-11;

if PROJdgn.p < 0.3
    RADEV.D = 4200;
else
    RADEV.D = 3600;
end
RADEV.relprojlenmeas = 'Yes';

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
