%===========================================
%
%===========================================

function [KSMP,err] = kSampGrdCUDA_v1a_Func(KSMP,INPUT)

global COMPASSINFO

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
MaskFoV = INPUT.MaskFoV;
clear INPUT;

%---------------------------------------------
% Get Gridding Ksz
%---------------------------------------------
Type = 'M2A';
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
if B0Map ~= 0
    err.flag = 1;
    err.msg = 'Off resonance sampling required for B0 analysis';
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
% Mask k-Space
%---------------------------------------------
Ob = OB.Ob;
if strcmp(MaskFoV,'Yes')
    K = fftshift(ifftn(ifftshift(Ob)));
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
end

%---------------------------------------------
% ZeroFill / Reverse Filter Object
%---------------------------------------------
zfOb = zeros(ZF,ZF,ZF);
zfOb(Imbot:Imtop,Imbot:Imtop,Imbot:Imtop) = Ob;
zfOb = zfOb./IFprms.V;
ftOb = fftshift(fftn(ifftshift(zfOb)));
%figure(1001);
%plot(real(ftOb(:,ZF/2+1,ZF/2+1)));

%---------------------------------------------
% Sample
%---------------------------------------------
Status2('busy','Reverse Gridding',2);
StatLev = 3;
[Dat,err] = mG2SCUDADoubleC_v4g(ZF,Kx,Ky,Kz,KERN,ftOb,CONV,StatLev,COMPASSINFO.CUDA);
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




