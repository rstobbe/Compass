%=========================================================
%
%=========================================================

function [BUILD,err] = BuildClientData_PreNormalized_v1a_Func(BUILD,INPUT)

Status2('busy','Build Client Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-------------------------------------------------
% Get input
%-------------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.PROJdgn;
PROJimp = IMP.PROJimp;
RawData = INPUT.RawData; 
KRNprms = INPUT.KERN.KERN;
clear INPUT

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;
SS = KRNprms.DesforSS;
Kmat = IMP.Kmat;
SDC = IMP.SDC;
Kern = KRNprms.Kern;

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
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4c(Kmat,nproj,npro,kstep,CONV.chW,SS,'M2M');       % this is slow - fix...
clear Kmat

%---------------------------------------------
% Test
%---------------------------------------------
ZF = 0;
ZFrel = 1;
if ZF == 0
    ZF = 2*round(ZFrel*Ksz/2);
end
if rem(ZF,2)
    error
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

sz = size(Kx);
Kx = single(reshape(Kx,[1 sz]));
Ky = single(reshape(Ky,[1 sz]));
Kz = single(reshape(Kz,[1 sz]));
SDC = single(reshape(SDC,[1 sz]));

%---------------------------------------------
% Build
%---------------------------------------------
ClientData = cat(1,Kx,Ky,Kz,SDC,RawData);
ClientData = permute(ClientData,[3 2 1]);

iKern = int32(KERN.iKern);
chW = int32(CONV.chW);
Ksz = int32(ZF);

save('TestData','ClientData','Kern','iKern','chW','Ksz');

%--------------------------------------------
% Panel
%--------------------------------------------
% Panel(1,:) = {'','','Output'};
% Panel(2,:) = {'',SYSWRT.method,'Output'};
% Panel(3,:) = {'Dummies',SYSWRT.dummies,'Output'};
% SYSWRT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);

