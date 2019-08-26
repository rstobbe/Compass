%=========================================================
% (v1b)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MotCorMSYB_RotationOnly_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Correct for Rotation (MSYB)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('ImpCor_Name',{SCRPTipt.labelstr});
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
MOTCOR.rotcorfunc = SCRPTGBL.CurrentTree.('RotCorfunc').Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
IMPCOR = SCRPTGBL.('ImpCor_File_Data').IMP;
SDCS = SCRPTGBL.('SDC_File_Data').SDCS;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;
SDC = SDCS.SDC;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ROTCORipt = SCRPTGBL.CurrentTree.('RotCorfunc');
if isfield(SCRPTGBL,('RotCorfunc_Data'))
    ROTCORipt.RotCorfunc_Data = SCRPTGBL.RotCorfunc_Data;
end

%------------------------------------------
% Get Object Shift Correction Function Info
%------------------------------------------
func = str2func(MOTCOR.rotcorfunc);           
[SCRPTipt,ROTCOR,err] = func(SCRPTipt,ROTCORipt);
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
INPUT.ROTCOR = ROTCOR;
[MOTCOR,err] = func(INPUT);
if err.flag
    return
end
IMP = MOTCOR.IMP;

%--------------------------------------------
% Return
%--------------------------------------------
kmatname = inputdlg('Name ProjImpCor:','Name',1,{'ProjImpCor_'});
if isempty(kmatname)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('ImpCor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(kmatname);

SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveGlobalNames = cell2mat(kmatname);
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(kmatname);

Status('done','');
Status2('done','',2);
Status2('done','',3);
