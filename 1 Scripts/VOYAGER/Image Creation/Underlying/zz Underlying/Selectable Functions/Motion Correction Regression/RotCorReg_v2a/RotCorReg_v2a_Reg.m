%=========================================================
% 
%=========================================================

function E = RotCorReg_v2a_Reg(V,ROTCORREG,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
DAT = INPUT.DAT;
IMG = INPUT.IMG;
Im0 = INPUT.Im0;
imthresh = INPUT.imthresh;
imagefunc = INPUT.imagefunc;
npro = IMP.PROJimp.npro;
clear INPUT

%---------------------------------------------
% Rotate k-Space locations
%---------------------------------------------
Karr = permute(Kmat,[2 1]);
Karr = Rotate3DPoints_v1a(Karr,V(1),V(2),V(3));
Kmat = ones(1,npro,3);
Kmat(1,:,:) = permute(Karr,[2 1]);

%-----------------------------------------
% Create Image
%-----------------------------------------
IMP.Kmat = Kmat;
INPUT.IMP = IMP;
INPUT.DAT = DAT;
[IMG,err] = imagefunc(IMG,INPUT);
if err.flag
    error(err.msg);
end
Im = abs(IMG.Im);
Im = flipdim(Im,1);         % only for simulation (should fix ksamp)
Im = flipdim(Im,2);
Im = flipdim(Im,3);    
Im = Im/max(Im(:));
Im(Im < imthresh) = 0;
PlotImage(Im,'abs',0,1,101); 

%-----------------------------------------
% Error Vector
%-----------------------------------------
E = Im(:) - Im0(:);


%====================================================
% Plot Image
%====================================================
function PlotImage(Im,type,min,max,fighnd) 

sz = size(Im);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = type; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [min max]; IMSTRCT.SLab = 0; IMSTRCT.figno = fighnd; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [500 500];
AxialMontage_v2a(Im,IMSTRCT);  


  