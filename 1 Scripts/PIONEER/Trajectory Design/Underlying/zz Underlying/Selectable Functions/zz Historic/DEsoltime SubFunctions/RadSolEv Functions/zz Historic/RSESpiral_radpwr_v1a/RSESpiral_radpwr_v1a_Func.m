%====================================================
%
%====================================================

function [RADEV,err] = RSESpiral_radpwr_v1a_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
%PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = ['(1./(abs(r.^',RADEV.pval,')*p))']; 

%---------------------------------------------
% Define tolerance for diffeq solver
%---------------------------------------------
RADEV.intol = 1e-6;
RADEV.outtol = 1e-7;
RADEV.D = 3900;

pval = str2double(RADEV.pval);
if pval == 0
    RADEV.relprojlenmeas = 'Yes';
else
    RADEV.relprojlenmeas = 'No';
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
RADEV.PanelOutput = struct();
Status2('done','',3);
