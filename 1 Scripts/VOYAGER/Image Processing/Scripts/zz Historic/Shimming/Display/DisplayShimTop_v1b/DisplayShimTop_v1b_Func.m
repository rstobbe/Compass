%===========================================
% 
%===========================================

function [DISP,err] = DisplayShimTop_v1b_Func(DISP,INPUT)

Status('busy','Display Shims');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
SHIM = INPUT.SHIM;
PLOT = INPUT.PLOT;
clear INPUT;

%---------------------------------------------
% Plot Full B0 Map
%---------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.AbsIm = SHIM.AbsIm;
INPUT.fMap = SHIM.fMap;
INPUT.Mask = SHIM.Mask;
INPUT.Prof = SHIM.Prof;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------

Status2('done','',2);
Status2('done','',3);

