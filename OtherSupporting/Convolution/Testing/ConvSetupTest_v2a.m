%=========================================================
% (v2a)
%   - new framework
%=========================================================

function [Ksz,SubSamp,Kx,Ky,Kz,KERN,CONV,err] = ConvSetupTest_v2a(STCH,KRN,type)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Kmat = permute(STCH.ReconInfoMat(:,:,1:3),[2 1 3]);
sz = size(Kmat);

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = STCH.kStep;
npro = STCH.NumCol;
nproj = sz(1);
SubSamp = KRN.DesforSS;

%---------------------------------------------
% Convolution Kernel Tests
%---------------------------------------------
if rem(round(1e9*(1/(KRN.res*SubSamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*SubSamp) not an integer';
    return
elseif rem((KRN.W/2)/KRN.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

%---------------------------------------------
% Convolution Kernel Setup
%---------------------------------------------
KERN.W = KRN.W*SubSamp;
KERN.res = KRN.res*SubSamp;
KERN.iKern = round(1e9*(1/(KRN.res*SubSamp)))/1e9;
KERN.Kern = KRN.Kern;
CONV.chW = ceil(((KRN.W*SubSamp)-2)/2);                    % with mFCMexSingleR_v3
if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize Trajectories to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4c(Kmat,nproj,npro,kstep,CONV.chW,SubSamp,type);




