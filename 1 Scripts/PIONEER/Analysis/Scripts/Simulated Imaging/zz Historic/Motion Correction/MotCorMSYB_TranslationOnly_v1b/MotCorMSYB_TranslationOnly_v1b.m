%=========================================================
% (v1b)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MotCorMSYB_TranslationOnly_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Correct for Motion (MSYB)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('KSMPcor_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'ImpCor_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load ImpCor_File';
    return
end
if not(isfield(SCRPTGBL,'SDC_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load SDC_File';
    return
end
if not(isfield(SCRPTGBL,'kSamp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Samp_File';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
MOTCOR.method = SCRPTGBL.CurrentTree.Func;
MOTCOR.transcorfunc = SCRPTGBL.CurrentTree.('TransCorfunc').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
IMPCOR = SCRPTGBL.('ImpCor_File_Data').IMP;
SDCS = SCRPTGBL.('SDC_File_Data').SDCS;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;
SDC = SDCS.SDC;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TRANSCORipt = SCRPTGBL.CurrentTree.('TransCorfunc');
if isfield(SCRPTGBL,('TransCorfunc_Data'))
    TRANSCORipt.TransCorfunc_Data = SCRPTGBL.TransCorfunc_Data;
end

%------------------------------------------
% Get Object Shift Correction Function Info
%------------------------------------------
func = str2func(MOTCOR.transcorfunc);           
[SCRPTipt,TRANSCOR,err] = func(SCRPTipt,TRANSCORipt);
if err.flag
    return
end

%---------------------------------------------
% Correct For Motion
%---------------------------------------------
func = str2func([MOTCOR.method,'_Func']);
INPUT.MOTCOR = MOTCOR;
INPUT.IMP = IMP;
INPUT.IMPCOR = IMPCOR;
INPUT.SDC = SDC;
INPUT.KSMP = KSMP;
INPUT.TRANSCOR = TRANSCOR;
[MOTCOR,err] = func(INPUT);
if err.flag
    return
end
SAMP = MOTCOR.KSMP;

%--------------------------------------------
% Return
%--------------------------------------------
dataname = inputdlg('Name KSMPcor:','Name',1,{'KSMPcor_'});
if isempty(dataname)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('KSMPcor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(dataname);

SCRPTGBL.RWSUI.SaveVariables = {SAMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'SAMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveGlobalNames = cell2mat(dataname);
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(dataname);

Status('done','');
Status2('done','',2);
Status2('done','',3);
