%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PerfSampSDC_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Perfect Sampling Array SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('SDC_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Imp_File';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
SDCS.method = SCRPTGBL.CurrentTree.Func;
SDCS.TFfunc = SCRPTGBL.CurrentTree.TFfunc.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TFipt = SCRPTGBL.CurrentTree.('TFfunc');
if isfield(SCRPTGBL,('TFfunc_Data'))
    TFipt.TFfunc_Data = SCRPTGBL.TFfunc_Data;
end

%------------------------------------------
% Get TF Function Info
%------------------------------------------
func = str2func(SDCS.TFfunc);           
[SCRPTipt,TF,err] = func(SCRPTipt,TFipt);
if err.flag
    return
end

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([SDCS.method,'_Func']);
INPUT.SDCS = SDCS;
INPUT.IMP = IMP;
INPUT.TF = TF;
[SDCS,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Perfect Sampling:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('SDC_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SDCS};
SCRPTGBL.RWSUI.SaveVariableNames = {'SDCS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'SDC_pfct';

Status('done','');
Status2('done','',2);
Status2('done','',3);
