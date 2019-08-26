%===========================================
% (v2c)
%   - start with kSpace Sample (v2c)
%===========================================

function [SCRPTipt,SCRPTGBL,err] = kSpaceSampleRotation_v2c(SCRPTipt,SCRPTGBL)

Status('busy','Sample kSpace with Rotation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Sampling_Name',{SCRPTipt.labelstr});
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
    err.msg = '(Re) Load Imp_File';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
SAMP.method = SCRPTGBL.CurrentTree.Func;
SAMP.ObjectFunc = SCRPTGBL.CurrentTree.Objectfunc.Func;
SAMP.ObRotFunc = SCRPTGBL.CurrentTree.ObRotfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
OBipt = SCRPTGBL.CurrentTree.('Objectfunc');
if isfield(SCRPTGBL,('Objectfunc_Data'))
    OBipt.Objectfunc_Data = SCRPTGBL.Objectfunc_Data;
end
ROTipt = SCRPTGBL.CurrentTree.('ObRotfunc');
if isfield(SCRPTGBL,('ObRotfunc_Data'))
    ROTipt.ObRotfunc_Data = SCRPTGBL.ObRotfunc_Data;
end

%------------------------------------------
% Get Object Function Info
%------------------------------------------
func = str2func(SAMP.ObjectFunc);           
[SCRPTipt,OB,err] = func(SCRPTipt,OBipt);
if err.flag
    return
end

%------------------------------------------
% Get Rotation Function Info
%------------------------------------------
func = str2func(SAMP.ObRotFunc);           
[SCRPTipt,ROT,err] = func(SCRPTipt,ROTipt);
if err.flag
    return
end

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;

%---------------------------------------------
% Sample k-Space
%---------------------------------------------
func = str2func([SAMP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.SAMP = SAMP;
INPUT.OB = OB;
INPUT.ROT = ROT;
[SAMP,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Sampling:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Sampling_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SAMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'SAMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);
