%=========================================================
% 
%=========================================================

function [IEFF,err] = AddB0_v1a_Func(IEFF,INPUT)

Status('busy','Add B0 Offset');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
B0 = INPUT.B0;
clear INPUT;

%---------------------------------------------
% Add B0 Offset
%---------------------------------------------
func = str2func([IEFF.B0func,'_Func']);  
INPUT.KSMP = KSMP;
INPUT.IMP = IMP;
[B0,err] = func(B0,INPUT);
if err.flag
    return
end
clear INPUT;
SampDat = B0.SampDat;

%---------------------------------------------
% Return
%---------------------------------------------
IEFF.SampDat = SampDat;

Status('done','');
Status2('done','',2);
Status2('done','',3);
