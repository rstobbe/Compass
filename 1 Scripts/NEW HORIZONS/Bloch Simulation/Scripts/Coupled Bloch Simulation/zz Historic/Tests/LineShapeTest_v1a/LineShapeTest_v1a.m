%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LineShapeTest_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Test / Plot Line Shape');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Sim_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
SIMDES.script = SCRPTGBL.CurrentTree.Func;
SIMDES.T2 = str2double(SCRPTGBL.CurrentTree.('T2'));
SIMDES.linevalfunc = SCRPTGBL.CurrentTree.('LineShapeValfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
LINEVALipt = SCRPTGBL.CurrentTree.('LineShapeValfunc');
if isfield(SCRPTGBL,('LineShapeValfunc_Data'))
    LINEVALipt.LineShapeValfunc_Data = SCRPTGBL.LineShapeValfunc_Data;
end

%------------------------------------------
% Line Shape Function Info
%------------------------------------------
func = str2func(SIMDES.linevalfunc);           
[SCRPTipt,LINEVAL,err] = func(SCRPTipt,LINEVALipt);
if err.flag
    return
end

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([SIMDES.script,'_Func']);
INPUT.LINEVAL = LINEVAL;
[SIMDES,err] = func(SIMDES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Simulation:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Sim_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SIMDES};
SCRPTGBL.RWSUI.SaveVariableNames = {'SIMDES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
