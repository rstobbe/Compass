%====================================================
%  
%====================================================

function [MAP,err] = R2Smap_ME_v1a_Func(MAP,INPUT)

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
mask(mask < 0.05*max(mask(:))) = 0;
mask(mask >= 0.05*max(mask(:))) = 1;

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
MAP.Im = CALC.Im;

Status2('done','',2);
Status2('done','',3);

