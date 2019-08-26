%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CreateSimMotCorMSYB_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Simulated Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
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
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.motcorfunc = SCRPTGBL.CurrentTree.MotCorfunc.Func;
IMG.imagecreatefunc = SCRPTGBL.CurrentTree.ImageCreatefunc.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
SDCS = SCRPTGBL.('SDC_File_Data').SDCS;
KSMP = SCRPTGBL.('kSamp_File_Data').SAMP;
SDC = SDCS.SDC;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ICipt = SCRPTGBL.CurrentTree.('ImageCreatefunc');
if isfield(SCRPTGBL,('ImageCreatefunc_Data'))
    ICipt.ImageCreatefunc_Data = SCRPTGBL.ImageCreatefunc_Data;
end
MOTCORipt = SCRPTGBL.CurrentTree.('MotCorfunc');
if isfield(SCRPTGBL,('MotCorfunc_Data'))
    MOTCORipt.MotCorfunc_Data = SCRPTGBL.MotCorfunc_Data;
end

%------------------------------------------
% Get Motion Correction Function Info
%------------------------------------------
func = str2func(IMG.motcorfunc);           
[SCRPTipt,MOTCOR,err] = func(SCRPTipt,MOTCORipt);
if err.flag
    return
end

%------------------------------------------
% Get Image Create Function Info
%------------------------------------------
func = str2func(IMG.imagecreatefunc);           
[SCRPTipt,IC,err] = func(SCRPTipt,ICipt);
if err.flag
    return
end

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.IMG = IMG;
INPUT.IMP = IMP;
INPUT.SDC = SDC;
INPUT.KSMP = KSMP;
INPUT.MOTCOR = MOTCOR;
INPUT.IC = IC;
[IMG,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'Img';

Status('done','');
Status2('done','',2);
Status2('done','',3);
