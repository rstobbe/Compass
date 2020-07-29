%===========================================
%
%===========================================

function [KSMP,err] = kSampGrdCUDAwOffRes_v1g_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
IMP = INPUT.IMP;
B0Map = INPUT.B0Map;
IFprms = KSMP.IFprms;
KRNprms = KSMP.KRNprms;
clear INPUT;

%---------------------------------------------
% Get Gridding Ksz
%---------------------------------------------
Status2('busy','Setup Reverse Gridding',2);
Type = 'M2A';
[Ksz,SubSamp,Kx,Ky,Kz,KERN,CONV,err] = ConvSetupTest_v1b(IMP,KRNprms,Type);

%---------------------------------------------
% Setup / Test
%---------------------------------------------
ZF = IFprms.ZF;
if Ksz > ZF
    err.flag = 1;
    err.msg = ['ZF must be greater than ',num2str(Ksz)];
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
% ZeroFill / Reverse Filter Object
%---------------------------------------------
zfOb = zeros(ZF,ZF,ZF);
Imbot = (ZF-OB.ObMatSz)/2 + 1;
Imtop = (ZF+OB.ObMatSz)/2;
zfOb(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop) = OB.Ob;
zfOb = zfOb./IFprms.V;
zfOb = ifftshift(zfOb);

%---------------------------------------------
% B0Map
%---------------------------------------------
T = IMP.samp/1000;                  % in ms
Off = zeros(ZF,ZF,ZF);
Off(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop) = B0Map;
Off = ifftshift(Off);

%---------------------------------------------
% Sample
%---------------------------------------------
Status2('busy','kSpace Sample',2);
StatLev = 3;
%[Dat,err] = mSampOffResCUDADoubles_v1h(zfOb,Off,T,Kx,Ky,Kz,KERN,CONV,StatLev);
[Dat,err] = mSampOffResCUDADoubles_v1j(zfOb,Off,T,Kx,Ky,Kz,KERN,CONV,StatLev);
if err.flag
    return
end

%---------------------------------------------
% Scale
%---------------------------------------------
Dat = Dat/KRNprms.convscaleval;

%---------------------------------------------
% Return
%---------------------------------------------
KSMP.SampDat = Dat;
KSMP.OB = OB;
KSMP.ZF = ZF;

