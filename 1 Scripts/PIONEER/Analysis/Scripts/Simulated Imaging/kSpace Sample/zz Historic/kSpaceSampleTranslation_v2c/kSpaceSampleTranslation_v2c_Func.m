%====================================================
%
%====================================================

function [SAMP,err] = kSpaceSampleTranslation_v2c_Func(INPUT)

Status('busy','Sample k-Space with Object Translation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SAMP = INPUT.SAMP;
OB = INPUT.OB;
TRANS = INPUT.TRANS;
IMP = INPUT.IMP;
PROJimp = IMP.PROJimp;
PROJdgn = IMP.impPROJdgn;
Kmat = IMP.Kmat;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
kstep = PROJdgn.kstep;
npro = PROJimp.npro;
nproj = PROJimp.nproj;

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

%----------------------------------------------------
% Plot Object
%----------------------------------------------------
plotob = 0;
if plotob == 1
    hnd = figure; PlotObject(Ob,hnd); 
end

%---------------------------------------------
% Sample
%---------------------------------------------
SampDat = Sample(Kmat,nproj,npro,kstep,Ob,ObFoV);    

%---------------------------------------------
% Translate
%---------------------------------------------
func = str2func([SAMP.TransFunc,'_Func']);  
INPUT.IMP = IMP;
INPUT.SampDat = SampDat;
[TRANS,err] = func(TRANS,INPUT);
if err.flag
    return
end
clear INPUT
SampDat = TRANS.SampDat;

%---------------------------------------------
% Return
%---------------------------------------------
SAMP.TRANS = TRANS;
SAMP.SampDat = SampDat;
SAMP.ObFoV = ObFoV;
SAMP.OB = OB;


%====================================================
% Sample
%====================================================
function [SampDat] = Sample(Kmat,nproj,npro,kstep,Ob,ObFoV)

%---------------------------------------------
% Normalize
%---------------------------------------------
[kSampArr0] = KMat2Arr(Kmat,nproj,npro);
kSampArr = kSampArr0/kstep;                         % every kstep spaced at 1 grid location. 
rel = (ObFoV/1000)*kstep;                           % adjust sampling according to relative FoV
kSampArr = kSampArr*rel;

%---------------------------------------------
% Test
%---------------------------------------------
test1 = max(abs(kSampArr(:)));
if (test1*2) > length(Ob)
    err.flag = 1;
    err.msg = 'Use Object Function with Larger Matrix and/or Smaller Object FoV'; 
    return
end
[x,y] = size(kSampArr);
if y ~= 3
    error();
end

%---------------------------------------------
% Sample
%---------------------------------------------
Status2('busy','Sampling with GPU',2);
Status2('busy','This may take a while...',3);
tic
[SampDat] = mDirectFTCUDAs_v1a(Ob,kSampArr');
toc


%====================================================
% Plot Object
%====================================================
function PlotObject(Ob,fighnd) 

sz = size(Ob);
minval = 0;
maxval = 1;
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [minval maxval]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [600 600];
AxialMontage_v2a(Ob,IMSTRCT);  
