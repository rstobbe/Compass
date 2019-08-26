%====================================================
%
%====================================================

function [EDDY,err] = EddyCurrents_v1c_Func(EDDY,INPUT)

Status('busy','Determine Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
POSBG = INPUT.POSBG;
TF = INPUT.TF;
clear INPUT

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func([EDDY.psbgfunc,'_Func']);
INPUT.Sys = EDDY.Sys;
[POSBG,err] = func(POSBG,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Transient Fields
%-----------------------------------------------------
func = str2func([EDDY.tffunc,'_Func']);
INPUT.Sys = EDDY.Sys;
INPUT.POSBG = POSBG;
[TF,err] = func(TF,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
StudyDisp = TF.ExpDisp.TF_ExpDisp.StudyDisp;
PosLocDisp = POSBG.ExpDisp.PL_ExpDisp.ParamsDisp;
NoGradDisp = POSBG.ExpDisp.BG_ExpDisp.ParamsDisp;
TFDisp = TF.ExpDisp.TF_ExpDisp.ParamsDisp;
PLoutput = PanelStruct2Text(POSBG.PanelOutput);
EDDY.ExpDisp = [StudyDisp PosLocDisp char(10) NoGradDisp char(10) TFDisp PLoutput];

%--------------------------------------------
% Output Structure
%--------------------------------------------
EDDY.Loc1 = POSBG.Loc1;
EDDY.Loc2 = POSBG.Loc2;
EDDY.Sep = POSBG.Sep;
EDDY.gval = TF.gval;
EDDY.Time = TF.Time;
EDDY.Geddy = TF.Geddy;
EDDY.B0eddy = TF.B0eddy;
EDDY.POSBG = POSBG;
EDDY.TF = TF;
EDDY.graddir = TF.Params.graddir;

Status('done','');
Status2('done','',2);
Status2('done','',3);
