%====================================================
%
%====================================================

function [MFEVO,err] = Meas_MagFieldEvolution_v1d_Func(INPUT,MFEVO)

Status('busy','Determine Magnetic Field Evolution');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
POSBG = INPUT.POSBG;
TF = INPUT.TF;
clear INPUT

%-----------------------------------------------------
% Get Scanner Data
%-----------------------------------------------------
func = str2func([MFEVO.fevolfunc,'_Func']);
INPUT = [];
[FEVOL,err] = func(FEVOL,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func([MFEVO.psbgfunc,'_Func']);
INPUT.FEVOL = FEVOL;
[POSBG,err] = func(POSBG,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Save Figures
%----------------------------------------------------
if isfield(POSBG,'Figure')
    MFEVO.Figure = POSBG.Figure;
    POSBG = rmfield(POSBG,'Figure');
end

%-----------------------------------------------------
% Determine Transient Fields
%-----------------------------------------------------
func = str2func([MFEVO.tffunc,'_Func']);
INPUT.POSBG = POSBG;
INPUT.FEVOL = FEVOL;
[TF,err] = func(TF,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Save Figures
%----------------------------------------------------
if isfield(TF,'Figure')
    MFEVO.Figure = [MFEVO.Figure TF.Figure];
    TF = rmfield(TF,'Figure');
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
MFEVO.ExpDisp = [char(10) FEVOL.ExpDisp char(10) POSBG.ExpDisp char(10) TF.ExpDisp];

%--------------------------------------------
% Output Structure
%--------------------------------------------
MFEVO.FEVOL = FEVOL;
MFEVO.Loc1 = POSBG.Loc1;
MFEVO.Loc2 = POSBG.Loc2;
MFEVO.Sep = POSBG.Sep;
MFEVO.gval = TF.gval;
MFEVO.Time = TF.Time;
MFEVO.GradField = TF.Geddy;
MFEVO.B0Field = TF.B0eddy;
MFEVO.POSBG = POSBG;
MFEVO.TF = TF;
MFEVO.graddir = TF.Params.graddir;

Status('done','');
Status2('done','',2);
Status2('done','',3);
