%====================================================
%
%====================================================

function [SDCS,err] = FindPointsVicinity_v1a_Func(INPUT,RDAT)

Status('busy','Find Sampling Points in Cartesian Vicinity');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP = INPUT.IMP;
if isfield(IMP,'impPROJdgn');
    PROJdgn = IMP.impPROJdgn;
else
    PROJdgn = IMP.PROJdgn;
end
KRNprms = INPUT.KRNprms;
PROJimp = IMP.PROJimp;
Kmat = IMP.Kmat;
clear INPUT

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

%--------------------------------------------
% Find Points
%--------------------------------------------
StatLev = 3;
[VcPts] = FindVicinityPoints_v1b(Ksz,Kx,Ky,Kz,KERN,StatLev);

whos
%---------------------------------------------
% Find Longest Segment
%---------------------------------------------
vcptslen = zeros(1,Ksz^3);
m = 1;
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            if not(isempty(VcPts{x,y,z}))
                vcptslen(m) = length(VcPts{x,y,z});
                m = m+1; 
            end
        end
    end
end
vcptslen = vcptslen(1:m-1);
figure(1000);
hist(vcptslen,1000);

ArrW3len = length(find(vcptslen < KRNprms.W^3));
VcPtsArrW3 = zeros(ArrW3len,KRNprms.W^3);
LocArrW3 = zeros(ArrW3len,3);

m = 1;
for x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            if not(isempty(VcPts{x,y,z}))
                if length(VcPts{x,y,z}) < KRNprms.W^3
                    
                    m = m+1; 
            end
        end
    end
end

%ArrW3 = zeros(
%if length(VcPts{x,y,z}) < KRNprms.W^3
                    
                   

%--------------------------------------------
% Output
%--------------------------------------------
SDCS.SDC = IT.SDC;
SDCS.TFO = TFO;
SDCS.CTFV = CTFV;
SDCS.IE = IE;
SDCS.IT = IT;



