%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_SDC_TrjSelSub_v1b_Func(INPUT)

Status('busy','Grid Portion of Data with SDC');
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
Kmat = IMP.Kmat;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
SDC = INPUT.SDCS.SDC;
GRDU = INPUT.GRDU;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
subdiam = GRD.subdiam;
kstep = PROJdgn.kstep;

%---------------------------------------------
% To Matrix
%---------------------------------------------
SDCmat = SDCArr2Mat(SDC,nproj,npro);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (subdiam/2),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subSDCmat = SDCmat(:,1:subnpro,:);

%---------------------------------------------
% Isolate Proj
%---------------------------------------------
if strcmp(GRD.traj,'All')
    Kmat = subKmat;
    DAT = subSDCmat;
else
    nproj = 1;
    traj = str2double(GRD.traj);
    Kmat = subKmat(traj,:,:);
    DAT = subSDCmat(traj,:,:);
end  

%---------------------------------------------
% Consolidate
%---------------------------------------------
IMP.impPROJdgn.kmax = subkmax;
IMP.PROJimp.nproj = nproj;
IMP.PROJimp.npro = subnpro;
IMP.Kmat = Kmat;

%---------------------------------------------
% Grid
%---------------------------------------------
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


