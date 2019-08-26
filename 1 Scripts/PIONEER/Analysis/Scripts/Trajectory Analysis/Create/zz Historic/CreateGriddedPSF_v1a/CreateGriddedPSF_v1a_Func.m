%=========================================================
% 
%=========================================================

function [CREATE,err] = CreateGriddedPSF_v1a_Func(INPUT,CREATE)

Status('busy','Create Gridded PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
SDC = INPUT.SDCS.SDC;
INVF = INPUT.INVF;
GRDU = INPUT.GRDU;
EFCT = INPUT.EFCT;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = IMP.PROJimp.nproj;
npro = IMP.PROJimp.npro;
ZF = INVF.ZF;

%---------------------------------------------
% To Matrix
%---------------------------------------------
SDCmat = SDCArr2Mat(SDC,nproj,npro);

%---------------------------------------------
% Effect (on data)
%---------------------------------------------
func = str2func([CREATE.effectaddfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.SampDat = SDCmat;
[EFCT,err] = func(EFCT,INPUT);
if err.flag
    return
end
SampDat = EFCT.SampDat;
clear INPUT;

sz = size(SampDat);
if sz(2) == 1
    SampDat = DatArr2Mat(SampDat,nproj,npro);
end

%----------------------------------------------------
% Grid
%----------------------------------------------------
func = str2func([CREATE.gridfunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.DAT = SampDat;
GRDU.type = 'real';
[GRDU,err] = func(GRDU,INPUT);
if err.flag
    return
end
clear INPUT;
GrdDat = GRDU.GrdDat;
SS = GRDU.SS;
Ksz = GRDU.Ksz;

%---------------------------------------------
% Test
%---------------------------------------------
if not(isfield(INVF,'Elip'))
    INVF.Elip = 1;
end
if Ksz > ZF*INVF.Elip
    err.flag = 1;
    err.msg = ['Zero-Fill is to small. Ksz = ',num2str(Ksz)];
    return
end

%---------------------------------------------
% Zero Fill / FT
%---------------------------------------------
Status2('busy','Zero-Fill / FT',2);
ZFTF = zeros([ZF,ZF,ZF]);
sz = size(GrdDat);
bot = (ZF-sz(1))/2+1;
top = bot+sz(1)-1;
ZFTF(bot:top,bot:top,bot:top) = GrdDat;

zfdims = size(INVF.V);                        % elip stuff
bot = ((zfdims(1)-zfdims(3))/2)+1; 
top = zfdims(1)-bot+1;
ZFTF = ZFTF(:,:,bot:top);

PSF = fftshift(ifftn(ifftshift(ZFTF)));

%---------------------------------------------
% Inverse Filter
%---------------------------------------------
PSF = PSF./INVF.V;

%---------------------------------------------
% ReturnFov
%---------------------------------------------
returnfov = 'Yes';
if strcmp(returnfov,'Yes')
    bot = ZF*(SS-1)/(2*SS)+1;
    top = ZF*(SS+1)/(2*SS);
    bot = floor(bot);
    top = ceil(top);
    bot2 = zfdims(3)*(SS-1)/(2*SS)+1;
    top2 = zfdims(3)*(SS+1)/(2*SS);
    bot2 = floor(bot2);
    top2 = ceil(top2);
    PSF = PSF(bot:top,bot:top,bot2:top2);
end

%--------------------------------------------
% Return
%--------------------------------------------
sz = size(PSF);
figure(1000);
plot(real(PSF(:,sz(2)/2+1,sz(3)/2+1)));

%--------------------------------------------
% Return
%--------------------------------------------
ZFTF = fftshift(ifftn(ifftshift(PSF)));
figure(1002); hold on;
rZFTF = ZFTF/ZFTF(sz(1)/2+1,sz(2)/2+1,sz(3)/2+1);
plot(real(rZFTF(:,sz(2)/2+1,sz(3)/2+1)));
plot(imag(rZFTF(:,sz(2)/2+1,sz(3)/2+1)));

CREATE.tf = real(rZFTF);
CREATE.PROJdgn = IMP.PROJdgn;

