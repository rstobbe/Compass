%===========================================
% 
%===========================================

function [IMG,err] = R2StarMapLoad_v1a_Func(IMG,INPUT)

Status2('busy','Calculate R2StarMap',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IM0 = INPUT.IM0;
CALC = INPUT.CALC;
clear INPUT;

%---------------------------------------------
% Filter
%---------------------------------------------
func = str2func([IMG.calcfunc,'_Func']);  
INPUT.IM0 = IM0;
INPUT.visuals = IMG.visuals;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = CALC.Im;


Status2('done','',2);
Status2('done','',3);

