%====================================================
%  
%====================================================

function [MAP,err] = R2Smap_ME_v1b_Func(MAP,INPUT)

Status2('busy','Generate R2Smap (Multi-Echo)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IM0;
Im = abs(IMG.Im);                   % absolute value
ExpPars = IMG.ExpPars;
visuals = INPUT.visuals;
CALC = MAP.CALC;
clear INPUT;

%---------------------------------------------
% Get TE
%---------------------------------------------
te = ExpPars.te;
esp = ExpPars.esp;
ne = ExpPars.ne;
TEarr = (te:esp:te+(ne-1)*esp)*1000;

%---------------------------------------------
% Mask
%---------------------------------------------
mask = Im(:,:,:,1);
mask(mask < MAP.maskval*max(mask(:))) = 0;
mask(mask >= MAP.maskval*max(mask(:))) = 1;

%---------------------------------------------
% Display Abs Image
%---------------------------------------------
sz = size(Im);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 2; IMSTRCT.stop = sz(3); 
IMSTRCT.rows = floor(sqrt(sz(3))+2); IMSTRCT.lvl = [0 max(abs(Im(:)))]; IMSTRCT.SLab = 0; IMSTRCT.figno = 100; 
IMSTRCT.docolor = 0; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [900 1500];
[h1,ImSz] = ImageMontageRGB_v1a(Im,IMSTRCT);

%---------------------------------------------
% Display Mask Image
%---------------------------------------------
IMSTRCT.SLab = 1;
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 2]; IMSTRCT.docolor = 1; 
[h2,ImSz] = ImageMontageRGB_v1a(mask,IMSTRCT);

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
IMSTRCT.type = 'real'; IMSTRCT.lvl = [0 1];
[smask,~] = ImageMontageSetup_v1a(mask/5,IMSTRCT);
smask(isnan(smask)) = 0;
set(h2,'alphadata',smask);     

%---------------------------------------------
% Mask and Scale
%---------------------------------------------
button = questdlg('Continue');
if not(strcmp(button,'Yes'))
    err.flag = 1;
    err.msg = 'User Aborted';
    return
end

%---------------------------------------------
% Runc R2Start map
%---------------------------------------------
func = str2func([MAP.calcfunc,'_Func']);  
INPUT.Im = Im;
INPUT.TEarr = TEarr;
INPUT.visuals = visuals;
INPUT.mask = mask;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = CALC.Im;
MAP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

