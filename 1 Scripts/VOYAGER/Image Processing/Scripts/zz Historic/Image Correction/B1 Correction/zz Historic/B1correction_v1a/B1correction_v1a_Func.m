%====================================================
%  
%====================================================

function [B1CORR,err] = B1correction_v1a_Func(B1CORR,INPUT)

Status('busy','B1-Correction');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG0 = INPUT.IMG;
B1MAP = INPUT.B1MAP;
CORF = INPUT.CORF;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1CORR.corrfunc,'_Func']);  
INPUT.IMG = IMG0;
INPUT.B1MAP = B1MAP;
[CORF,err] = func(CORF,INPUT);
if err.flag
    return
end
clear INPUT;
IMG = CORF.IMG;

%---------------------------------------------
% B1 Map
%---------------------------------------------

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([B1CORR.dispfunc,'_Func']);  
INPUT.IMG1 = IMG0;
INPUT.IMG2 = IMG;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B1CORR.IMG = IMG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);