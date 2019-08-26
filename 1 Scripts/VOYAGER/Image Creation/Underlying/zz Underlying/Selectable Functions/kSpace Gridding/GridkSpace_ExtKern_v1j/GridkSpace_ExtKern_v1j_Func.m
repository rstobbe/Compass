%=========================================================
% 
%=========================================================

function [GRD,err] = GridkSpace_ExtKern_v1j_Func(GRD,INPUT)

global CUDA

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SampDat = INPUT.DAT;
IMP = INPUT.IMP;
if isfield(INPUT,'ZF')
    ZF = INPUT.ZF;
else
    ZF = 0;
end
Kmat = IMP.Kmat;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
KRNprms = INPUT.KRNprms;
if isfield(INPUT,'StatLev')
    StatLev = INPUT.StatLev;
else
    StatLev = 2;
end
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
SS = KRNprms.DesforSS;

%---------------------------------------------
% Convolution Kernel Tests
%---------------------------------------------
if rem(round(1e9*(1/(KRNprms.res*SS)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*SS) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

%---------------------------------------------
% Convolution Kernel Setup
%---------------------------------------------
KERN.W = KRNprms.W*SS;
KERN.res = KRNprms.res*SS;
KERN.iKern = round(1e9*(1/(KRNprms.res*SS)))/1e9;
KERN.Kern = KRNprms.Kern;
CONV.chW = ceil(((KRNprms.W*SS)-2)/2);                    % with mFCMexSingleR_v3
if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize Trajectories to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4b(Kmat,nproj,npro,kstep,CONV.chW,SS,'M2A');
clear Kmat

%---------------------------------------------
% Test
%---------------------------------------------
if ZF == 0
    ZF = Ksz+1;
end
if Ksz > ZF
    err.flag = 1;
    err.msg = ['Zero-Fill is to small. Ksz = ',num2str(Ksz)];
    return
end

%---------------------------------------------
% k-Samp Shift
%---------------------------------------------
shift = (ZF/2+1)-((Ksz+1)/2);
Kx = Kx+shift;
Ky = Ky+shift;
Kz = Kz+shift;

%---------------------------------------------
% Put In Array
%---------------------------------------------
[SampDat] = DatMat2Arr(SampDat,IMP.PROJimp.nproj,IMP.PROJimp.npro);

%---------------------------------------------
% Grid Data
%---------------------------------------------
CUDAdevice = CUDA;
if strcmp(GRD.type,'real');
    [GrdDat,err] = mS2GCUDADoubleR_v4f(ZF,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev,CUDAdevice);
elseif strcmp(GRD.type,'complex');
    [GrdDat,err] = mS2GCUDADoubleC_v4f(ZF,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev,CUDAdevice);
end

%---------------------------------------------
% Scale
%---------------------------------------------
GrdDat = GrdDat/KRNprms.convscaleval;

%--------------------------------------------
% Remove Kernel from KRNprms (no need to save)
%--------------------------------------------
KRNprms = rmfield(KRNprms,'Kern');

%--------------------------------------------
% Return
%--------------------------------------------
GRD.GrdDat = GrdDat;
GRD.Ksz = Ksz;
GRD.SS = SS;
GRD.KRNprms = KRNprms;

%---------------------------------------------
% Status
%---------------------------------------------
if StatLev == 2
    Status2('done','',2);
end
Status2('done','',3);


