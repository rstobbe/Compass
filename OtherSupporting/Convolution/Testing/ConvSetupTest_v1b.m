%=========================================================
% (v1b)
%   - include projsampscnr
%=========================================================

function [Ksz,SubSamp,Kx,Ky,Kz,KERN,CONV,err] = ConvSetupTest_v1b(IMP,KRNprms,type)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
if isfield(IMP,'impPROJdgn')
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
PROJimp = IMP.PROJimp;
if not(isfield(IMP,'OverProj'))
    Kmat = IMP.Kmat(IMP.projsampscnr,:,:);
else
    if strcmp(IMP.OverProj,'Yes')
        Kmat = IMP.Kmat(IMP.projsampscnr,:,:);
    else
        Kmat = IMP.Kmat;
    end
end
sz = size(Kmat);

%---------------------------------------------
% Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = sz(1);
SubSamp = KRNprms.DesforSS;

%---------------------------------------------
% Convolution Kernel Tests
%---------------------------------------------
if rem(round(1e9*(1/(KRNprms.res*SubSamp)))/1e9,1)
    err.flag = 1;
    err.msg = '1/(kernres*SubSamp) not an integer';
    return
elseif rem((KRNprms.W/2)/KRNprms.res,1)
    err.flag = 1;
    err.msg = '(W/2)/kernres not an integer';
    return
end

%---------------------------------------------
% Convolution Kernel Setup
%---------------------------------------------
KERN.W = KRNprms.W*SubSamp;
KERN.res = KRNprms.res*SubSamp;
KERN.iKern = round(1e9*(1/(KRNprms.res*SubSamp)))/1e9;
KERN.Kern = KRNprms.Kern;
CONV.chW = ceil(((KRNprms.W*SubSamp)-2)/2);                    % with mFCMexSingleR_v3
if (CONV.chW+1)*KERN.iKern > length(KERN.Kern)
    err.flag = 1;
    err.msg = 'zW of Kernel not large enough';
    return
end

%---------------------------------------------
% Normalize Trajectories to Grid
%---------------------------------------------
[Ksz,Kx,Ky,Kz,C] = NormProjGrid_v4c(Kmat,nproj,npro,kstep,CONV.chW,SubSamp,type);




