%===========================================
% 
%===========================================

function [ISHIM,err] = ShimImageIntensitySphH_v1b_Func(ISHIM,INPUT)

Status2('busy','Intensity Shim',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
FIT = ISHIM.FIT;
clear INPUT;

%---------------------------------------------
% Scale and Mask
%---------------------------------------------
Im0 = abs(IMG.Im);
Im = Im0;
Im = Im/max(Im(:));
NaNProf = zeros(size(Im));
NaNProf(Im < 0.15) = 1;
NaNProf(Im > 0.5) = 1;
NaNProf = logical(NaNProf);
Im(NaNProf) = NaN;

%---------------------------------------------
% Display
%---------------------------------------------
sz = size(Im);
mxd = sz(3);
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [0 0.5]; IMSTRCT.SLab = 0; IMSTRCT.figno = 1000; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
ImageMontage_v2a(Im,IMSTRCT);

%---------------------------------------------
% Fit Spherical Harmonics
%---------------------------------------------
INPUT.Im = Im;
func = str2func([ISHIM.fitfunc,'_Func']);
[FIT,err] = func(FIT,INPUT);
if err.flag
    return
end
clear INPUT    

%---------------------------------------------
% Prof
%--------------------------------------------- 
V = FIT.V
Prof = FIT.Prof;
%Prof(NaNProf) = 1;

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2001; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
ImageMontage_v2a(Prof,IMSTRCT);

%---------------------------------------------
% Correct
%---------------------------------------------
Im2 = Im./Prof;
Im2 = Im2/max(Im2(:));

%---------------------------------------------
% Display
%---------------------------------------------
IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = round(mxd/20); IMSTRCT.stop = mxd; 
IMSTRCT.rows = 5; IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 2002; 
IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
ImageMontage_v2a(Im2,IMSTRCT);



Status2('done','',2);
Status2('done','',3);

