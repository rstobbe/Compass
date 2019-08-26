%===========================================
% 
%===========================================

function [CMAP,err] = ConcMapping_v1a_Func(CMAP,INPUT)

Status('busy','Map Concentration');
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
% B0 Map
%---------------------------------------------
func = str2func([CMAP.mapfunc,'_Func']);  
INPUT.Im = IMG.Im;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
Im = MAP.Im;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([CMAP.dispfunc,'_Func']);  
INPUT.Im = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im;
CMAP.IMG = IMG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

