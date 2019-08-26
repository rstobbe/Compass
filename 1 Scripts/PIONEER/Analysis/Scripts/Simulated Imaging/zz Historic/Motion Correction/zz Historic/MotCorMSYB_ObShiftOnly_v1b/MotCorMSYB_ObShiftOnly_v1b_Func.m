%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorMSYB_ObShiftOnly_v1b_Func(INPUT)

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
KSMP = INPUT.KSMP;
SDC = INPUT.SDC;
OBSHFT = INPUT.OBSHFT;
clear INPUT;

%----------------------------------------------
% Correct for Object Shifts
%----------------------------------------------
func = str2func([MOTCOR.obshftcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;   
INPUT.SDC = SDC;
[OBSHFT,err] = func(OBSHFT,INPUT);
if err.flag
    return
end
clear INPUT;
Kmat = OBSHFT.Kmat;
SampDat = OBSHFT.SampDat;
OBSHFT = rmfield(OBSHFT,'Kmat');
OBSHFT = rmfield(OBSHFT,'SampDat');

%---------------------------------------------
% Update
%---------------------------------------------
IMP.Kmat = Kmat;
IMP.OBSHFT = OBSHFT;
KSMP.SampDat = SampDat;
KSMP.OBSHFT = OBSHFT;

%---------------------------------------------
% Return
%---------------------------------------------
MOTCOR.IMP = IMP;
MOTCOR.KSMP = KSMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);