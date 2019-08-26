%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorMSYB_TranslationOnly_v1b_Func(INPUT)

Status('busy','Correct for Motion (MSYB)');
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
TRANSCOR = INPUT.TRANSCOR;
clear INPUT;

%----------------------------------------------
% Correct for Object Shifts
%----------------------------------------------
func = str2func([MOTCOR.transcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.IMPCOR = IMPCOR;
INPUT.KSMP = KSMP;   
INPUT.SDC = SDC;
[TRANSCOR,err] = func(TRANSCOR,INPUT);
if err.flag
    return
end
clear INPUT;
SampDat = TRANSCOR.SampDat;
TRANSCOR = rmfield(TRANSCOR,'SampDat');

%---------------------------------------------
% Update
%---------------------------------------------
KSMP.SampDat = SampDat;
KSMP.TRANSCOR = TRANSCOR;

%---------------------------------------------
% Return
%---------------------------------------------
MOTCOR.KSMP = KSMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);