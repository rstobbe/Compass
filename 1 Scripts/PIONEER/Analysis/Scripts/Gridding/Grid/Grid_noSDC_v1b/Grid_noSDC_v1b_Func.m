%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_noSDC_v1b_Func(INPUT)

Status('busy','Grid Data with no SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
IMP = INPUT.IMP;
GRDU = INPUT.GRDU;
clear INPUT;

%---------------------------------------------
% Data
%---------------------------------------------
DAT = ones(size(IMP.Kmat));

%----------------------------------------------------
% Grid
%----------------------------------------------------
func = str2func([GRD.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DAT;
GRDU.type = 'real';
[GRDU,err] = func(GRDU,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Return
%--------------------------------------------
GRD.GrdDat = GRDU.GrdDat;
GRD.Ksz = GRDU.Ksz;
OUTPUT.GRD = GRD;


