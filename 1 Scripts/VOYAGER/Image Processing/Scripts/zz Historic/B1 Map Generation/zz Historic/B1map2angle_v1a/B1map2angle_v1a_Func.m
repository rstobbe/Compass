%====================================================
%  
%====================================================

function [B1MAP,err] = B1map2angle_v1a_Func(B1MAP,INPUT)

Status('busy','Generate B1map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

Im10 = IMG{1}.Im;
Im20 = IMG{2}.Im;

Im1 = Im10(:,:,:,1);
Im2 = Im20(:,:,:,1);

%---------------------------------------------
% Mask
%---------------------------------------------
B1MAP.MV = 0.5;

mask = abs(Im1);
mask(mask < B1MAP.MV) = 0;
mask(mask >= B1MAP.MV) = 1;

%---------------------------------------------
% Calc
%---------------------------------------------
Imrel = Im1./Im2;
Imflip = acos(1./(2*Imrel));
B1rel = (Imflip*180/pi)/B1MAP.specflip1;

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = B1rel .* mask;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(B1MAP.Im);
IMSTRCT.type = 'real'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+1); IMSTRCT.lvl = [0.85 1.15]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
AxialMontage_v2a(B1MAP.Im,IMSTRCT);

%---------------------------------------------
% Volume
%---------------------------------------------
mask2 = abs(B1MAP.Im);
mask2(mask2 > 0.7) = 1;
mask2(mask2 <= 0.7) = 0;
tot = sum(mask2(:));
vol = tot*6.592/1000;

Status('done','');
Status2('done','',2);
Status2('done','',3);

