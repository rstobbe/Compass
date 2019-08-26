%=========================================================
% 
%=========================================================

function E = AlignImages_v1a_Reg(V,ALGN,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
Im1 = abs(INPUT.IMG{1}.Im);
Im2 = abs(INPUT.IMG{2}.Im);
clear INPUT

Im1(Im1 < 0.05*max(Im1(:))) = 0;
Im2(Im2 < 0.05*max(Im2(:))) = 0;

%---------------------------------------------
% Transform Image
%---------------------------------------------
%V = [0 0 0 5 0 0];
tIm2 = Transform3DMatrix_v1b(Im2,V(1),V(2),V(3),V(4),V(5),V(6));

%-----------------------------------------
% Error Vector
%-----------------------------------------
tIm2 = tIm2 * V(7);
E = tIm2(:) - Im1(:);
V

%====================================================
% Plot Image
%====================================================
sz = size(Im1);
rows = floor(sqrt(sz(3))); 
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [0 max(Im1(:))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [500 500];
AxialMontage_v2a(Im1,IMSTRCT);  

IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [0 max(tIm2(:))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [500 500];
AxialMontage_v2a(tIm2,IMSTRCT);  

sIm = Im1 - tIm2;
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = rows; IMSTRCT.lvl = [-max(abs(sIm(:))) max(abs(sIm(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 3; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; 
IMSTRCT.figsize = [500 500];
AxialMontage_v2a(sIm,IMSTRCT); 
%error();
  