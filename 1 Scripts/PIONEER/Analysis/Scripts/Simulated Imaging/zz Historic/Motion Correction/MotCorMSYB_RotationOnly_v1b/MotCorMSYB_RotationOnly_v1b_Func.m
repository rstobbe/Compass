%=========================================================
% 
%=========================================================

function [MOTCOR,err] = MotCorMSYB_RotationOnly_v1b_Func(INPUT)

Status('busy','Correct for Rotation (MSYB)');
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
ROTCOR = INPUT.ROTCOR;
clear INPUT;

%----------------------------------------------
% Correct for Rotation
%----------------------------------------------
func = str2func([MOTCOR.rotcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.IMPCOR = IMPCOR;
INPUT.KSMP = KSMP;   
INPUT.SDC = SDC;
[ROTCOR,err] = func(ROTCOR,INPUT);
if err.flag
    return
end
clear INPUT;
Kmat = ROTCOR.Kmat;
ROTCOR = rmfield(ROTCOR,'Kmat');

%---------------------------------------------
% Update
%---------------------------------------------
IMP.Kmat = Kmat;
IMP.ROTCOR = ROTCOR;

%---------------------------------------------
% Return
%---------------------------------------------
MOTCOR.IMP = IMP;

Status('done','');
Status2('done','',2);
Status2('done','',3);