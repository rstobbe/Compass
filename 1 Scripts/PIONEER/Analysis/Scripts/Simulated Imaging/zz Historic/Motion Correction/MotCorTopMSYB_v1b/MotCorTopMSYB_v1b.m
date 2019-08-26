%=========================================================
% (v1b)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MotCorTopMSYB_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Correct for Motion (MSYB)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('kSpaceLocCor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
inds = strcmp('DataCor_Name',{SCRPTipt.labelstr});
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
TOP.method = SCRPTGBL.CurrentTree.Func;
TOP.motcorfunc = SCRPTGBL.CurrentTree.MotCorfunc.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
SDCS = SCRPTGBL.('SDC_File_Data').SDCS;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;
SDC = SDCS.SDC;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MOTCORipt = SCRPTGBL.CurrentTree.('MotCorfunc');
if isfield(SCRPTGBL,('MotCorfunc_Data'))
    MOTCORipt.MotCorfunc_Data = SCRPTGBL.MotCorfunc_Data;
end

%------------------------------------------
% Get Motion Correction Function Info
%------------------------------------------
func = str2func(TOP.motcorfunc);           
[SCRPTipt,MOTCOR,err] = func(SCRPTipt,MOTCORipt);
if err.flag
    return
end

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([TOP.method,'_Func']);
INPUT.TOP = TOP;
INPUT.IMP = IMP;
INPUT.SDC = SDC;
INPUT.KSMP = KSMP;
INPUT.MOTCOR = MOTCOR;
[TOP,err] = func(INPUT);
if err.flag
    return
end
IMP = TOP.IMP;
SAMP = TOP.KSMP;

%--------------------------------------------
% Return
%--------------------------------------------
kmatname = inputdlg('Name Sampled k-Space Location Correction:');
if isempty(kmatname)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
dataname = inputdlg('Name Data Correction:');
if isempty(dataname)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('kSpaceLocCor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(kmatname);
inds = strcmp('DataCor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(dataname);

SCRPTGBL.RWSUI.SaveVariables = {IMP,SAMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP','SAMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveGlobalNames = {cell2mat(kmatname),cell2mat(dataname)};
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = {cell2mat(kmatname),cell2mat(dataname)};

Status('done','');
Status2('done','',2);
Status2('done','',3);
