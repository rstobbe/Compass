%=========================================================
% 
%=========================================================

function [PLOTTOP,err] = Plot_Implementation_v1a_Func(PLOTTOP,INPUT)

Status('busy','Plot Implementation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
PLOT = INPUT.PLOT;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([PLOTTOP.plotfunc,'_Func']);  
INPUT.IMP = IMP;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
