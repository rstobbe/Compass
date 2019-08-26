%=========================================================
% 
%=========================================================

function [TOP,err] = MotCorTopMSYB_v1a_Func(INPUT)

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
arrSDC = INPUT.SDC;
arrDAT = KSMP.SampDat;
MOTCOR = INPUT.MOTCOR;
clear INPUT;

%---------------------------------------------
% Compensate Data
%---------------------------------------------
arrDAT = arrDAT.*arrSDC;
[DAT] = DatArr2Mat(arrDAT,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%----------------------------------------------
% Correct for Motion
%----------------------------------------------
func = str2func([TOP.motcorfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
INPUT.KSMP = KSMP;      % for testing...
[MOTCOR,err] = func(MOTCOR,INPUT);
if err.flag
    return
end
clear INPUT;
Kmat = MOTCOR.Kmat;
MOTCOR = rmfield(MOTCOR,'Kmat');

%---------------------------------------------
% Return
%---------------------------------------------
TOP.Kmat = Kmat;
TOP.MOTCOR = MOTCOR;

Status('done','');
Status2('done','',2);
Status2('done','',3);