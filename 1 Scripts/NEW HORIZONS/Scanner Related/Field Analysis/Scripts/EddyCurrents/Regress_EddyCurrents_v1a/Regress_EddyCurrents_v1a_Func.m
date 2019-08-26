%==================================================
% 
%==================================================

function [RGRS,err] = Regress_EddyCurrents_v1a_Func(RGRS,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
REGMETH = INPUT.REGMETH;
clear INPUT;

%---------------------------------------------
% Plot Type
%---------------------------------------------
func = str2func([RGRS.eddyregressfunc,'_Func']);
INPUT.MFEVO = MFEVO;
[REGMETH,err] = func(REGMETH,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
RGRS.REGMETH = REGMETH;
RGRS.PanelOutput = REGMETH.PanelOutput;

Status('done','');
Status2('done','',2);
Status2('done','',3);