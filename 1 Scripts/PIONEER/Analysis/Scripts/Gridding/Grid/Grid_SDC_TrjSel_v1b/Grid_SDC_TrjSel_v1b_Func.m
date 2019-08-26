%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_SDC_TrjSel_v1b_Func(INPUT)

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

%---------------------------------------------
% Isolate
%---------------------------------------------
if strcmp(GRD.traj,'All')
    IMP.PROJimp.nproj = IMP.PROJimp.nproj; 
    DAT = SDCmat;
else
    traj = str2double(GRD.traj);
    IMP.Kmat = IMP.Kmat(traj,:,:);
    IMP.PROJimp.nproj = 1;
    DAT = SDCmat(traj,:,:);
end  

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


