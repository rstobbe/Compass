%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_Data_TrjSelSub_v1b_Func(INPUT)

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
DAT = INPUT.KSMP.SampDat;
GRDU = INPUT.GRDU;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJimp.nproj;
npro = PROJimp.npro;
subdiam = GRD.subdiam;
kstep = PROJdgn.kstep;

%---------------------------------------------
% To Matrix
%---------------------------------------------
DAT = SDC.*DAT;
DATmat = DatArr2Mat(DAT,nproj,npro);

%---------------------------------------------
% Isolate Centre
%---------------------------------------------
rad = (sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2))/kstep;
rad = mean(rad,1);
subnpro = find(rad < (subdiam/2),1,'last');
subkmax = rad(subnpro)*kstep;
subKmat = Kmat(:,1:subnpro,:);
subDATmat = DATmat(:,1:subnpro,:);

%---------------------------------------------
% Isolate Proj
%---------------------------------------------
if strcmp(GRD.traj,'All')
    Kmat = subKmat;
    DAT = subDATmat;
else
    nproj = 1;
    traj = str2double(GRD.traj);
    Kmat = subKmat(traj,:,:);
    DAT = subDATmat(traj,:,:);
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
GRD.SS = GRDU.SS;
OUTPUT.GRD = GRD;


