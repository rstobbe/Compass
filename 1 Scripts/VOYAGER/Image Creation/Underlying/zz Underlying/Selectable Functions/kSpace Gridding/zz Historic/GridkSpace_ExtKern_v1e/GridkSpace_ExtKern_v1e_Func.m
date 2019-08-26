%=========================================================
% 
%=========================================================

function [GRD,err] = GridkSpace_ExtKern_v1e_Func(GRD,INPUT)

Status2('busy','Grid Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DAT = INPUT.DAT;
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
KRNprms = INPUT.KRNprms;
if isfield(INPUT,'SubSamp')
    SS = INPUT.SubSamp;
    if isfield(KRNprms,'posSS') 
        ind = find(KRNprms.posSS == SS, 1);
        if isempty(ind);
            posSS = KRNprms.posSS
            error;
        end
    elseif isfield(KRNprms,'DesforSS')
        if KRNprms.DesforSS ~= SS
            error;
        end
    end
else
    SS = KRNprms.DesforSS;
end
StatLev = INPUT.StatLev;
clear INPUT;

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;

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
% Put Data in an Array
%---------------------------------------------
[SampDat] = DatMat2Arr(DAT,nproj,npro);

%---------------------------------------------
% Grid Data
%---------------------------------------------
if strcmp(GRD.implement,'Mex')
    if strcmp(GRD.precision,'Double')
        if strcmp(GRD.type,'real');
            [GrdDat,err] = mS2GMexDoubleR_v3a(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        elseif strcmp(GRD.type,'complex');
            [GrdDat,err] = mS2GMexDoubleC_v3a(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        end
    elseif strcmp(GRD.precision,'Single')
        if strcmp(GRD.type,'real');
            [GrdDat,err] = mS2GMexSingleR_v3a(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        elseif strcmp(GRD.type,'complex');
            [GrdDat,err] = mS2GMexSingleC_v3a(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        end 
    end
elseif strcmp(GRD.implement,'CUDA')    
    if strcmp(GRD.precision,'Double')
        if strcmp(GRD.type,'real');
            [GrdDat,err] = mS2GCUDADoubleR_v4d(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        elseif strcmp(GRD.type,'complex');
            [GrdDat,err] = mS2GCUDADoubleC_v4d(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        end
    elseif strcmp(GRD.precision,'Single')
        if strcmp(GRD.type,'real');
            [GrdDat,err] = mS2GCUDASingleR_v4d(Ksz,Kx,Ky,Kz,KERN,SampDat,CONV,StatLev);
        elseif strcmp(GRD.type,'complex');
            error();
        end 
    end
end

%---------------------------------------------
% Scale
%---------------------------------------------
GrdDat = GrdDat/(KRNprms.convscaleval);

%--------------------------------------------
% Return
%--------------------------------------------
GRD.GrdDat = GrdDat;
GRD.Ksz = Ksz;
GRD.SS = SS;

Status2('done','',2);
Status2('done','',3);


