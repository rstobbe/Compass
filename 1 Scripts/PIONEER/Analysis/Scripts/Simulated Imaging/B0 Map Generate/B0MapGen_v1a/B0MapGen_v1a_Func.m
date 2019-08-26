%===========================================
%
%===========================================

function [B0GEN,err] = B0MapGen_v1a_Func(INPUT,B0GEN)

Status('busy','Create B0 Map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
B0MAP = INPUT.B0MAP;
clear INPUT;

%----------------------------------------------------
% Build B0Map
%----------------------------------------------------
func = str2func([B0GEN.B0MapFunc,'_Func']);  
INPUT.ObMatSz = B0GEN.ObMatSz;
INPUT.SampFoV = B0GEN.SampFoV;
[B0MAP,err] = func(B0MAP,INPUT);
if err.flag
    return
end
clear INPUT;
Im = B0MAP.map;
B0MAP = rmfield(B0MAP,'map');

%----------------------------------------------------
% Plot Map
%----------------------------------------------------
plotob = 1;
if plotob == 1
    MSTRCT.step = ceil(B0GEN.ObMatSz/47);
    MSTRCT.start = MSTRCT.step*2;
    MSTRCT.stop = B0GEN.ObMatSz - MSTRCT.step*2;
    INPUT.Image = Im;
    INPUT.MSTRCT = MSTRCT;
    PlotMontage_v1c(INPUT);
end   
clear INPUT;

%---------------------------------------------
% Panel
%---------------------------------------------
B0GEN.PanelOutput = B0MAP.PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
B0GEN.Im = Im;
B0GEN.B0MAP = B0MAP;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);


