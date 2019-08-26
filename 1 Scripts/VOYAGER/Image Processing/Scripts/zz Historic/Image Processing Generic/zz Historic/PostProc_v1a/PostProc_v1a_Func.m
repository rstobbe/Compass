%===========================================
% 
%===========================================

function [PROC,err] = PostProc_v1a_Func(PROC,INPUT)

Status('busy','Post Process');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
FUNC = INPUT.FUNC;
clear INPUT;

%---------------------------------------------
% Run Function
%---------------------------------------------
func = str2func([PROC.procfunc,'_Func']);  
INPUT.IMG = IMG;
[FUNC,err] = func(FUNC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PROC.Im = FUNC.Im;
PROC.PanelOutput = IMG.PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

