%====================================================
%  
%====================================================

function [B1MAP,err] = B1Mapping2Ims_v1a_Func(B1MAP,INPUT)

Status('busy','Map B1');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
MAP = INPUT.MAP;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.mapfunc,'_Func']);  
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
[MAP,err] = func(MAP,INPUT);
if err.flag
    return
end
clear INPUT;
B1Map = MAP.Im;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([B1MAP.dispfunc,'_Func']);  
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
INPUT.Map = B1Map;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = MAP.Im;
B1MAP.ReconPars = IMG1.ReconPars;
B1MAP.ExpPars = IMG1.ExpPars;
B1MAP.PanelOutput = MAP.PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

