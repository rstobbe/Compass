%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MotCorDiffTopMSYB_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Correct for Motion in Diffusion Scan');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('MotCor_Name',{SCRPTipt.labelstr});
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
IMP.Kmat = TOP.Kmat;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Motion Correction:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('MotCor_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'ProjImpCor';

Status('done','');
Status2('done','',2);
Status2('done','',3);
