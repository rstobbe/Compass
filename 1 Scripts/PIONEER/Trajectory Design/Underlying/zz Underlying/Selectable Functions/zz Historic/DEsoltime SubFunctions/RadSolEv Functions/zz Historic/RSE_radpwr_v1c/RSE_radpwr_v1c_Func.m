%====================================================
%
%====================================================

function [RADEV,err] = RSE_radpwr_v1c_Func(RADEV,INPUT)

Status2('busy','Get Radial Evolution Function for DE Solving',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Define
%---------------------------------------------
RADEV.deradsolfunc = ['(1./(abs(r.^',RADEV.pval,')*p^2))']; 

%---------------------------------------------
% Define tolerance for diffeq solver
%---------------------------------------------
pval = str2double(RADEV.pval);
if pval <= 0.5 
    RADEV.intol = 1e-7;
    RADEV.outtol = 1e-11;
    RADEV.D = 4000;
elseif pval <= 1 
    RADEV.intol = 1e-9;
    RADEV.outtol = 1e-11;
    RADEV.D = 3000;
elseif pval <= 3 
    RADEV.intol = 1e-11;
    RADEV.outtol = 1e-11;
    if PROJdgn.p > 0.35
        RADEV.D = 3700;
    elseif PROJdgn.p > 0.3
        RADEV.D = 3600;
    elseif PROJdgn.p > 0.24
        RADEV.D = 2800;
    elseif PROJdgn.p > 0.12
        RADEV.D = 2900;
    elseif PROJdgn.p > 0.095
        RADEV.D = 2600;
    elseif PROJdgn.p > 0.06
        RADEV.D = 2600;
    else
        RADEV.D = 2300;
    end
end

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
