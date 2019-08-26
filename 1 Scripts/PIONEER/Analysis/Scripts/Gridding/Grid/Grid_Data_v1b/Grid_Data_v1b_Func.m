%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_Data_v1b_Func(INPUT)

Status('busy','Grid Data with SDC');
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
SDC = INPUT.SDCS.SDC;
DAT = INPUT.KSMP.SampDat;
GRDU = INPUT.GRDU;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;

%---------------------------------------------
% To Matrix
%---------------------------------------------
DAT = SDC.*DAT;
DATmat = DatArr2Mat(DAT,nproj,npro);

%----------------------------------------------------
% Grid
%----------------------------------------------------
func = str2func([GRD.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = DATmat;
GRDU.type = 'complex';
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


