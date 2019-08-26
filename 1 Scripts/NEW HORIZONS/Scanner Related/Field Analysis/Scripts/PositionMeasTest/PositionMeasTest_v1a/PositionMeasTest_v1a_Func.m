%====================================================
%
%====================================================

function [EDDY,err] = PositionMeasTest_v1a_Func(EDDY,INPUT)

Status('busy','Determine Probe Position');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
POSBG = INPUT.POSBG;
clear INPUT

%-----------------------------------------------------
% Load Test Files
%-----------------------------------------------------
func = str2func([EDDY.fevolfunc,'_Func']);
INPUT = struct();
[FEVOL,err] = func(FEVOL,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func([EDDY.psbgfunc,'_Func']);
INPUT.FEVOL = FEVOL;
[POSBG,err] = func(POSBG,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
EDDY.ExpDisp = [char(10) POSBG.ExpDisp];

%--------------------------------------------
% Output Structure
%--------------------------------------------
EDDY.FEVOL = FEVOL;
EDDY.Loc1 = POSBG.Loc1;
EDDY.Loc2 = POSBG.Loc2;
EDDY.Sep = POSBG.Sep;
EDDY.POSBG = POSBG;

Status('done','');
Status2('done','',2);
Status2('done','',3);
