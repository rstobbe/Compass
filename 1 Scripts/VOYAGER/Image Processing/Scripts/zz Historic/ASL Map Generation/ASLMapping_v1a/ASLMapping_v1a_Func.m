%===========================================
% 
%===========================================

function [RMAP,err] = ASLMapping_v1a_Func(RMAP,INPUT)

Status('busy','Create ASL Map');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Relative Map
%---------------------------------------------
func = str2func([RMAP.mapfunc,'_Func']);  
INPUT.Image = IMG.Im;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
Im = MAP.Im;

%---------------------------------------------
% Base Image
%---------------------------------------------
bIm = abs(mean(IMG.Im,4));
Im = cat(4,bIm,Im);

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([RMAP.dispfunc,'_Func']);  
INPUT.Im = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
RMAP.Im = Im;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

