%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Grid_Data_PerfSamp_v1b_Func(INPUT)

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
Kmat = IMP.Kmat;
SDC = INPUT.SDCS.SDC;
DAT = INPUT.KSMP.SampDat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
kstep = IMP.impPROJdgn.kstep;
maxkmax = IMP.impPROJdgn.kmax;

%---------------------------------------------
% Sampling Density Compensate
%---------------------------------------------
DAT = SDC.*DAT;

%---------------------------------------------
% Normalize to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4(Kmat,nproj,npro,maxkmax,kstep,0,1,'M2A');

%---------------------------------------------
% 'Grid'
%---------------------------------------------
GrdDat = zeros(Ksz,Ksz,Ksz);
for n = 1:length(Kx)
    GrdDat(Kx(n),Ky(n),Kz(n)) = DAT(n);
end

%--------------------------------------------
% Return
%--------------------------------------------
GRD.GrdDat = GrdDat;
GRD.Ksz = Ksz;
OUTPUT.GRD = GRD;


