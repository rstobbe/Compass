%====================================================
% 
%====================================================

function [SR,err] = GradStepResp_v1b_Func(SR,INPUT)

Status('busy','Determine Gradient Step Response');
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
func = str2func([SR.psbgfunc,'_Func']);
INPUT.Sys = SR.Sys;
[POSBG,err] = func(POSBG,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Transient Fields
%-----------------------------------------------------
func = str2func([SR.tffunc,'_Func']);
INPUT.Sys = SR.Sys;
INPUT.POSBG = POSBG;
[TF,err] = func(TF,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Experiment Parameter Display
%-----------------------------------------------------
StudyDisp = TF.ExpDisp.TF_ExpDisp.StudyDisp;
PosLocDisp = POSBG.ExpDisp.PL_ExpDisp.ParamsDisp;
NoGradDisp = POSBG.ExpDisp.BG_ExpDisp.ParamsDisp;
TFDisp = TF.ExpDisp.TF_ExpDisp.ParamsDisp;
SR.ExpDisp = [StudyDisp char(10) PosLocDisp char(10) NoGradDisp char(10) TFDisp];

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SR.PanelOutput = POSBG.PanelOutput;

%--------------------------------------------
% Output Structure
%--------------------------------------------
SR.Loc1 = POSBG.Loc1;
SR.Loc2 = POSBG.Loc1;
SR.Sep = POSBG.Sep;
SR.gval = TF.gval;
SR.Time = TF.Time;
SR.Geddy = TF.Geddy;
SR.B0eddy = TF.B0eddy;
SR.POSBG = POSBG;
SR.TF = TF;

Status('done','');
Status2('done','',2);
Status2('done','',3);
