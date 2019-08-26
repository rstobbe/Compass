%===========================================
%
%===========================================

function [KSMP,err] = kSampGrdCUDAwOffRes_v1d_Func(KSMP,INPUT)

Status2('busy','Sample k-Space',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
IMP = INPUT.IMP;
PROJdgn = IMP.impPROJdgn;
B0Map = INPUT.B0Map;
IFprms = KSMP.IFprms;
KRNprms = KSMP.KRNprms;
clear INPUT;

%---------------------------------------------
% Get Gridding Ksz
%---------------------------------------------
Type = 'M2M';
[Ksz,SubSamp,Kx,Ky,Kz,KERN,CONV,err] = ConvSetupTest_v1a(IMP,KRNprms,Type);
centre = (Ksz+1)/2;

%---------------------------------------------
% Setup / Test
%---------------------------------------------
ZF = IFprms.ZF;
if Ksz > ZF
    err.flag = 1;
    err.msg = ['ZF must be greater than ',num2str(Ksz)];
    return
end
if rem(ZF,SubSamp)
    err.flag = 1;
    err.msg = 'ZF must be a multiple of SubSamp';
    return
end
Imbot = ZF*(SubSamp-1)/(2*SubSamp)+1;
Imtop = ZF*(SubSamp+1)/(2*SubSamp);
Imsz = Imtop-Imbot+1;
if Imsz ~= OB.ObMatSz
    err.flag = 1;
    err.msg = ['ObMatSz must be ',num2str(Imsz)];
    return
end
sz = size(B0Map);
if B0Map == 0
    B0Map = zeros(Imsz,Imsz,Imsz);
elseif sz(1) ~= Imsz
    err.flag = 1;
    err.msg = 'ObMatSz must be same as B0MapSz';
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
% ZeroFill - Mask k-Space
%---------------------------------------------
K = fftshift(ifftn(ifftshift(OB.Ob)));
centre = OB.ObMatSz/2+1;
for n = 1:OB.ObMatSz
    for m = 1:OB.ObMatSz
        for p = 1:OB.ObMatSz
            rad = sqrt((n-centre)^2 + (m-centre)^2 + (p-centre)^2);
            if rad > PROJdgn.rad;
                K(n,m,p) = 0;
            end
        end
    end
end
Ob = fftshift(fftn(ifftshift(K)));

%---------------------------------------------
% ZeroFill / Reverse Filter Object
%---------------------------------------------
zfOb = zeros(ZF,ZF,ZF);
zfOb(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop) = Ob;
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
Status2('busy','Reverse Gridding',2);
StatLev = 3;
[Dat,err] = mSampOffResCUDADoubles_v1f(zfOb,Off,T,Kx,Ky,Kz,KERN,CONV,StatLev);
if err.flag
    return
end

%---------------------------------------------
% Scale
%---------------------------------------------
Dat = Dat/KRNprms.convscaleval;

%figure(100); hold on;
%plot(abs(SampDat),'k');
%plot(real(SampDat),'r');
%plot(imag(SampDat),'b');

%---------------------------------------------
% Return
%---------------------------------------------
KSMP.SampDat = Dat;
KSMP.OB = OB;




