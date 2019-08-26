%=========================================================
% 
%=========================================================

function [IEFF,err] = kSpaceShift_v1a_Func(INPUT)

Status('busy','Shift k-Space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
KSHFT = INPUT.KSHFT;
IEFF = INPUT.IEFF;
clear INPUT;

%---------------------------------------------
% Add T2
%---------------------------------------------
func = str2func([IEFF.kshftfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
[KSHFT,err] = func(KSHFT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IEFF.Kmat = KSHFT.Kmat;

Status('done','');
Status2('done','',2);
Status2('done','',3);
