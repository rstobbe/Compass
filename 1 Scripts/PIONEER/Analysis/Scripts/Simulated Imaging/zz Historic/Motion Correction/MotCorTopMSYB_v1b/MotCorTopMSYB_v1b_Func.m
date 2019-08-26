%=========================================================
% 
%=========================================================

function [TOP,err] = MotCorTopMSYB_v1b_Func(INPUT)

Status('busy','Correct for Motion (MSYB)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TOP = INPUT.TOP;
IMP = INPUT.IMP;
KSMP = INPUT.KSMP;
SDC = INPUT.SDC;
MOTCOR = INPUT.MOTCOR;
clear INPUT;

%----------------------------------------------
% Correct for Motion
%----------------------------------------------
func = str2func([TOP.motcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;   
INPUT.SDC = SDC;
[MOTCOR,err] = func(MOTCOR,INPUT);
if err.flag
    return
end
clear INPUT;
Kmat = MOTCOR.Kmat;
SampDat = MOTCOR.SampDat;
MOTCOR = rmfield(MOTCOR,'Kmat');
MOTCOR = rmfield(MOTCOR,'SampDat');

%---------------------------------------------
% Update
%---------------------------------------------
IMP.Kmat = Kmat;
IMP.MOTCOR = MOTCOR;
KSMP.SampDat = SampDat;
KSMP.MOTCOR = MOTCOR;

%---------------------------------------------
% Return
%---------------------------------------------
TOP.IMP = IMP;
TOP.KSMP = KSMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);