%=========================================================
% (v1b)
%       - update for function Splitting
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_Object_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Sample kSpace');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OBPLT.method = SCRPTGBL.CurrentTree.Func;
OBPLT.ObjectFunc = SCRPTGBL.CurrentTree.Objectfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
OBipt = SCRPTGBL.CurrentTree.('Objectfunc');
if isfield(SCRPTGBL,('Objectfunc_Data'))
    OBipt.Objectfunc_Data = SCRPTGBL.Objectfunc_Data;
end

%------------------------------------------
% Get Object Function Info
%------------------------------------------
func = str2func(OBPLT.ObjectFunc);           
[SCRPTipt,OB,err] = func(SCRPTipt,OBipt);
if err.flag
    return
end

%---------------------------------------------
% Plot Object
%---------------------------------------------
func = str2func([OBPLT.method,'_Func']);
INPUT.OBPLT = OBPLT;
INPUT.OB = OB;
[OBPLT,err] = func(INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SCRPTGBL.RWSUI.LocalOutput = OBPLT.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
Status2('done','',2);
Status2('done','',3);


