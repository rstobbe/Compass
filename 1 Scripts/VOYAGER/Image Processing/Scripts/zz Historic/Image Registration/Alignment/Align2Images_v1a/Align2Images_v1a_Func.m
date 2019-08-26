%====================================================
%  
%====================================================

function [RGSTR,err] = Align2Images_v1a_Func(RGSTR,INPUT)

Status('busy','Align2Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
ALGN = INPUT.ALGN;
clear INPUT;

%---------------------------------------------
% Align
%---------------------------------------------
func = str2func([RGSTR.alignfunc,'_Func']);  
INPUT.IMG = IMG;
[ALGN,err] = func(ALGN,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
RGSTR.Im = ALGN.Im;

Status('done','');
Status2('done','',2);
Status2('done','',3);

