%====================================================
% (v1b)
%       - Update Global Passing Update 
%====================================================

function [SCRPTipt,SCRPTGBL,err] = EddyCurrents_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Determine Gradient Eddies (RF pulse after gradient)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Eddy_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY.Sys = SCRPTGBL.CurrentTree.('System');
EDDY.B0cal = str2double(SCRPTGBL.CurrentTree.('B0'));
EDDY.Gcal = str2double(SCRPTGBL.CurrentTree.('G'));
EDDY.psbgfunc = SCRPTGBL.CurrentTree.('PosBgrndfunc').Func;
EDDY.tffunc = SCRPTGBL.CurrentTree.('TransFieldfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
POSBG = SCRPTGBL.CurrentTree.('PosBgrndfunc');
if isfield(SCRPTGBL,('PosBgrndfunc_Data'))
    POSBG.PosBgrndfunc_Data = SCRPTGBL.PosBgrndfunc_Data;
end
TF = SCRPTGBL.CurrentTree.('TransFieldfunc');
if isfield(SCRPTGBL,('TransFieldfunc_Data'))
    TF.TransFieldfunc_Data = SCRPTGBL.TransFieldfunc_Data;
end

%-----------------------------------------------------
% Determine Probe Displacement and BackGround Fields
%-----------------------------------------------------
func = str2func(EDDY.psbgfunc);
POSBG.EDDY = EDDY;
[SCRPTipt,POSBG,err] = func(SCRPTipt,POSBG);
if err.flag
    ErrDisp(err);
    return
end

%-----------------------------------------------------
% Determine Transient Fields
%-----------------------------------------------------
func = str2func(EDDY.tffunc);
TF.EDDY = EDDY;
TF.POSBG = POSBG;
[SCRPTipt,TF,err] = func(SCRPTipt,TF);
if err.flag
    ErrDisp(err);
    return
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
StudyDisp = TF.ExpDisp.TF_ExpDisp.StudyDisp;
PosLocDisp = POSBG.ExpDisp.PL_ExpDisp.ParamsDisp;
NoGradDisp = POSBG.ExpDisp.BG_ExpDisp.ParamsDisp;
TFDisp = TF.ExpDisp.TF_ExpDisp.ParamsDisp;
EDDY.ExpDisp = [StudyDisp char(10) PosLocDisp char(10) NoGradDisp char(10) TFDisp];
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
EDDY.PanelOutput = POSBG.PanelOutput;
SCRPTGBL.RWSUI.LocalOutput = EDDY.PanelOutput;

%--------------------------------------------
% Output Structure
%--------------------------------------------
EDDY.Loc1 = POSBG.Loc1;
EDDY.Loc2 = POSBG.Loc1;
EDDY.Sep = POSBG.Sep;
EDDY.gval = TF.gval;
EDDY.Time = TF.Time;
EDDY.Geddy = TF.Geddy;
EDDY.B0eddy = TF.B0eddy;
EDDY.POSBG = POSBG;
EDDY.TF = TF;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Analysis:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Eddy_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {EDDY};
SCRPTGBL.RWSUI.SaveVariableNames = {'EDDY'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};


