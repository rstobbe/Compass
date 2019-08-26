%==================================================
% 
%==================================================

function [PLOT,err] = Plot_FieldEvolution_v1a_Func(PLOT,INPUT)

Status('busy','Plot Field Evolutiont');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
FPLT = INPUT.FPLT;
clear INPUT;

%-----------------------------------------------------
% Plot Type
%-----------------------------------------------------
func = str2func([PLOT.fieldplotfunc,'_Func']);
INPUT.MFEVO = MFEVO;
[FPLT,err] = func(FPLT,INPUT);
if err.flag
    return
end
clear INPUT

Status('done','');
Status2('done','',2);
Status2('done','',3);