%=========================================================
% 
%=========================================================

function [GRD,err] = Grid_SDC_v1b_Func(INPUT,GRD)

Status('busy','Grid Data with SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
SDC = INPUT.SDCS.SDC;
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
SDCmat = SDCArr2Mat(SDC,nproj,npro);

%----------------------------------------------------
% Grid
%----------------------------------------------------
func = str2func([GRD.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = SDCmat;
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


