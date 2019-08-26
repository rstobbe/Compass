%===========================================
%
%===========================================

function [SAMP,err] = kSpaceSampleMultRcvr_Grd_v2c_Func(INPUT,SAMP)

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
RPROF = INPUT.RPROF;
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

%---------------------------------------------
% Build Object
%---------------------------------------------
func = str2func([SAMP.ObjectFunc,'_Func']);  
INPUT = struct();
[OB,err] = func(OB,INPUT);
if err.flag
    return
end
clear INPUT;
Ob = OB.Ob;
ObFoV = OB.ObFoV;

%---------------------------------------------
% Plot Object
%---------------------------------------------
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
[kSampArr0] = KMat2Arr(Kmat,nproj,npro);
kSampArr = kSampArr0/kstep;                         % every kstep spaced at 1 grid location. 
rel = (ObFoV/1000)*kstep;                           % adjust sampling according to relative FoV
kSampArr = kSampArr*rel;
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
% Add Reciever Profiles
%---------------------------------------------
func = str2func([SAMP.RcvProfFunc,'_Func']);  
INPUT.Ob = Ob;
[RPROF,err] = func(RPROF,INPUT);
if err.flag
    return
end
clear INPUT;
mOb = RPROF.mOb;
RcvrProf = RPROF.RcvrProf;
Nrcvrs = length(mOb(1,1,1,:));

%---------------------------------------------
% FT (zf fix...)
%---------------------------------------------
Dat = zeros(x,Nrcvrs);
zfkMat = zeros(79,79,79);
for n = 1:Nrcvrs
    zfkMat(1:78,1:78,1:78) = fftshift(fftn(ifftshift(squeeze(mOb(:,:,:,n)))));  
    %figure; (plot(abs(zfkMat(:,40,40))));
    
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
    Dat(:,n) = GRDR.SampDat;    
end

%---------------------------------------------
% Return
%---------------------------------------------
SAMP.SampDat = Dat;
SAMP.RcvrProf = RcvrProf;
SAMP.ObFoV = ObFoV;
SAMP.OB = OB;




