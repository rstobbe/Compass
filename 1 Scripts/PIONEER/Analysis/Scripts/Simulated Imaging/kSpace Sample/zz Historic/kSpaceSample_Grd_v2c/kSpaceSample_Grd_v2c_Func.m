%===========================================
%
%===========================================

function [SAMP,err] = kSpaceSample_Grd_v2c_Func(INPUT,SAMP)

Status('busy','Sample k-Space');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
OB = INPUT.OB;
IMP = INPUT.IMP;
GRDR = INPUT.GRDR;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJdgn.nproj;

%----------------------------------------------------
% Build Object
%----------------------------------------------------
func = str2func([SAMP.ObjectFunc,'_Func']);  
INPUT = struct();
[OB,err] = func(OB,INPUT);
if err.flag
    return
end
clear INPUT;
Ob = OB.Ob;
ObFoV = OB.ObFoV;
obsz = OB.ObMatSz;

%----------------------------------------------------
% Plot Object
%----------------------------------------------------
plotob = 1;
if plotob == 1
    sz = size(Ob);
    minval = 0;
    maxval = 1;
    rows = floor(sqrt(sz(3))); 
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
    IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2; 
    IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
    IMSTRCT.figsize = [1000 1000];
    AxialMontage_v2a(Ob,IMSTRCT);  
end

%---------------------------------------------
% Test
%---------------------------------------------


%---------------------------------------------
% FT (fix...
%---------------------------------------------
zfkMat = zeros(obsz+1,obsz+1,obsz+1);
zfkMat(1:obsz,1:obsz,1:obsz) = fftshift(fftn(ifftshift(Ob)));
figure; (plot(abs(zfkMat(:,(obsz+2)/2,(obsz+2)/2))));

%---------------------------------------------
% Sample
%---------------------------------------------
func = str2func([SAMP.GridRevFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.kDat = zfkMat;
GRDR.type = 'complex';
[GRDR,err] = func(GRDR,INPUT);
if err.flag
    return
end
clear INPUT;
SampDat = GRDR.SampDat;

%---------------------------------------------
% Return
%---------------------------------------------
SAMP.SampDat = SampDat;
SAMP.ObFoV = ObFoV;
SAMP.OB = OB;




