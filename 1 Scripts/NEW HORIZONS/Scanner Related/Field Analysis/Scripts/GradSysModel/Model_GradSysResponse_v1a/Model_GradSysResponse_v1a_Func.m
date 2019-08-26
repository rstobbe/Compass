%==================================================
% 
%==================================================

function [GSYSMOD,err] = Model_GradSysResponse_v1a_Func(GSYSMOD,INPUT)

Status('busy','Model Gradient System Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
MOD = INPUT.MOD;
clear INPUT;

%-----------------------------------------------------
% Plot Type
%-----------------------------------------------------
func = str2func([GSYSMOD.modelfunc,'_Func']);
INPUT.MFEVO = MFEVO;
[MOD,err] = func(MOD,INPUT);
if err.flag
    return
end
clear INPUT

GSYSMOD.ExpDisp = MOD.ExpDisp;
GSYSMOD.filtcoeff = MOD.filtcoeff; 
GSYSMOD.graddel = MOD.graddel; 
GSYSMOD.dwell = MOD.dwell;

Status('done','');
Status2('done','',2);
Status2('done','',3);