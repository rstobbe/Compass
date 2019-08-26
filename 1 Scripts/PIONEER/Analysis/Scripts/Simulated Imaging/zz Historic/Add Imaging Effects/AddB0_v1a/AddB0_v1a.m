%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = AddB0_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get B0 Data');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('ImagingEffect_Name',{SCRPTipt.labelstr});
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
elseif not(isfield(SCRPTGBL,'kSamp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Samp_File';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IEFF.method = SCRPTGBL.CurrentTree.Func;
IEFF.B0func = SCRPTGBL.CurrentTree.('B0func').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
B0ipt = SCRPTGBL.CurrentTree.('B0func');
if isfield(SCRPTGBL,('B0func_Data'))
    B0ipt.B0func_Data = SCRPTGBL.B0func_Data;
end

%------------------------------------------
% Get B0 Function Info
%------------------------------------------
func = str2func(IEFF.B0func);           
[SCRPTipt,B0,err] = func(SCRPTipt,B0ipt);
if err.flag
    return
end

%---------------------------------------------
% B0 Effect
%---------------------------------------------
func = str2func([IEFF.method,'_Func']);
INPUT.IMP = IMP;
INPUT.KSMP = KSMP;
INPUT.B0 = B0;
[IEFF,err] = func(IEFF,INPUT);
if err.flag
    return
end
clear INPUT;

SAMP = KSMP;
SAMP.SampDat = IEFF.SampDat;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name B0 Offset Data:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('ImagingEffect_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

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



