%====================================================
% (LR1)
%       - Standard Outward-progressing Yarn-Ball
% (a)
%       - no k-space overshoot for spiral effect
% (v8d)
%       - underlying function change to 'LR1_GenProj_v1d'
%====================================================

function [SCRPTipt,SCRPTGBL,err] = LR1a_v8f(SCRPTipt,SCRPTGBL)

Status('busy','Create Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Design_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJdgn.method = SCRPTGBL.CurrentTree.Func;
PROJdgn.fov = str2double(SCRPTGBL.CurrentTree.FoV);
PROJdgn.vox = str2double(SCRPTGBL.CurrentTree.Vox);
PROJdgn.tro = str2double(SCRPTGBL.CurrentTree.Tro);
PROJdgn.nproj = str2double(SCRPTGBL.CurrentTree.Nproj);
PROJdgn.spinfunc = SCRPTGBL.CurrentTree.Spinfunc.Func;
PROJdgn.desoltimfunc = SCRPTGBL.CurrentTree.DeSolTimfunc.Func;
PROJdgn.accconstfunc = SCRPTGBL.CurrentTree.ConstEvolfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SPINipt = SCRPTGBL.CurrentTree.('Spinfunc');
if isfield(SCRPTGBL,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = SCRPTGBL.Spinfunc_Data;
end
DESOLipt = SCRPTGBL.CurrentTree.('DeSolTimfunc');
if isfield(SCRPTGBL,('DeSolTimfunc_Data'))
    DESOLipt.DeSolTimfunc_Data = SCRPTGBL.DeSolTimfunc_Data;
end
CACCipt = SCRPTGBL.CurrentTree.('ConstEvolfunc');
if isfield(SCRPTGBL,('ConstEvolfunc_Data'))
    CACCipt.ConstEvolfunc_Data = SCRPTGBL.ConstEvolfunc_Data;
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(PROJdgn.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%------------------------------------------
% Get DE Solution Timing Function Info
%------------------------------------------
func = str2func(PROJdgn.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end

%------------------------------------------
% Get Acceleration Constraint Info
%------------------------------------------
func = str2func(PROJdgn.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end

%---------------------------------------------
% Generate LR1 Design
%---------------------------------------------
func = str2func([PROJdgn.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.DESOL = DESOL;
INPUT.CACC = CACC;
[DES,err] = func(INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%SCRPTGBL.RWSUI.LocalOutput = DES.PanelOutput;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
DES.ExpDisp = PanelStruct2Text(DES.PanelOutput);
set(findobj('tag','TestBox'),'string',DES.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Design:','Name',1,{'DES_'});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%--------------------------------------------
% Output
%--------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {DES};
SCRPTGBL.RWSUI.SaveVariableNames = {'DES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

