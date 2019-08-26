%=========================================================
% 
%=========================================================

function [CALCTOP,err] = CreateTrajPSD_v1a_Func(CALCTOP,INPUT)

Status('busy','Calculate PSD');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
CALC = INPUT.CALC;
clear INPUT

%---------------------------------------------
% Calculate PSD
%---------------------------------------------
func = str2func([CALCTOP.calcpsdfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.tfdiam = [];
INPUT.tforient = '';
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;
CALCTOP = CALC;
CALCTOP.PROJdgn = IMP.impPROJdgn;
