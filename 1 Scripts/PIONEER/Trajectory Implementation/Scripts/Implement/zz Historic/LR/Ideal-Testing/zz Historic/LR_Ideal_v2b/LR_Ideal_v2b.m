%=========================================================
% (2b) 
%       - Update for RWSUI_BA
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LR_Ideal_v2b(SCRPTipt,SCRPTGBL)

Status('busy','Implement Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Des_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Des_File';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJimp.method = SCRPTGBL.CurrentTree.Func;
PROJimp.system = SCRPTGBL.CurrentTree.System;
PROJimp.nucleus = SCRPTGBL.CurrentTree.Nucleus;
if strcmp(PROJimp.nucleus,'1H')
    PROJimp.gamma = 42.577;
elseif strcmp(PROJimp.nucleus,'23Na')
    PROJimp.gamma = 11.26;
end
PROJimp.orient = SCRPTGBL.CurrentTree.Orient;
PROJimp.psmpmeth = SCRPTGBL.CurrentTree.ProjSampfunc.Func;
PROJimp.tsmpmeth = SCRPTGBL.CurrentTree.TrajSampfunc.Func;
PROJimp.ksmpmeth = SCRPTGBL.CurrentTree.kSampfunc.Func;
testingonly = SCRPTGBL.CurrentTree.Testing_Only;

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
DES = SCRPTGBL.Des_File_Data.DES;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
PSMPipt = SCRPTGBL.CurrentTree.('ProjSampfunc');
if isfield(SCRPTGBL,('ProjSampfunc_Data'))
    PSMPipt.ProjSampfunc_Data = SCRPTGBL.ProjSampfunc_Data;
end
TSMPipt = SCRPTGBL.CurrentTree.('TrajSampfunc');
if isfield(SCRPTGBL,('TrajSampfunc_Data'))
    TSMPipt.TrajSampfunc_Data = SCRPTGBL.TrajSampfunc_Data;
end
KSMPipt = SCRPTGBL.CurrentTree.('kSampfunc');
if isfield(SCRPTGBL,('kSampfunc_Data'))
    KSMPipt.TrajSampfunc_Data = SCRPTGBL.kSampfunc_Data;
end

%------------------------------------------
% Get Projection Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.psmpmeth);           
[SCRPTipt,PSMP,err] = func(SCRPTipt,PSMPipt);
if err.flag
    return
end

%------------------------------------------
% Get Trajecory Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.tsmpmeth);           
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
if err.flag
    return
end

%------------------------------------------
% Get k-Space Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.ksmpmeth);           
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
if err.flag
    return
end

%---------------------------------------------
% Implement LR Design
%---------------------------------------------
func = str2func([PROJimp.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.DES = DES;
INPUT.PSMP = PSMP;
INPUT.TSMP = TSMP;
INPUT.KSMP = KSMP;
INPUT.testingonly = testingonly;
[IMP,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Finish Output Structure
%--------------------------------------------
IMP.impPROJdgn = DES.PROJdgn;
IMP.DES = DES;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Implementation:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

if strcmp(testingonly,'No');
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
    SCRPTGBL.RWSUI.SaveScriptName = 'ProjImp';
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
end

Status('done','');
Status2('done','',2);
Status2('done','',3);


