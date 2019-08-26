%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorMSYB_kShiftOnly_v1b_Func(INPUT)

Status('busy','Correct for kShift (MSYB)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MOTCOR = INPUT.MOTCOR;
IMP = INPUT.IMP;
IMPCOR = INPUT.IMPCOR;
KSMP = INPUT.KSMP;
SDC = INPUT.SDC;
KSHFTCOR = INPUT.KSHFTCOR;
clear INPUT;

%----------------------------------------------
% Correct for Rotation
%----------------------------------------------
func = str2func([MOTCOR.kshftcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.IMPCOR = IMPCOR;
INPUT.KSMP = KSMP;   
INPUT.SDC = SDC;
[KSHFTCOR,err] = func(KSHFTCOR,INPUT);
if err.flag
    return
end
clear INPUT;
Kmat = KSHFTCOR.Kmat;
KSHFTCOR = rmfield(KSHFTCOR,'Kmat');

%---------------------------------------------
% Update
%---------------------------------------------
IMP.Kmat = Kmat;
IMP.KSHFTCOR = KSHFTCOR;

%---------------------------------------------
% Return
%---------------------------------------------
MOTCOR.IMP = IMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);