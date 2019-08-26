%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateMult3DCartMap1_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Maps from 3D Cartesian Images');
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
% Load Input
%---------------------------------------------
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.importfidfunc = SCRPTGBL.CurrentTree.('ImportFIDfunc').Func;
IMG.dccorfunc = SCRPTGBL.CurrentTree.('DCcorfunc').Func;
IMG.prepfunc = SCRPTGBL.CurrentTree.('PreProcfunc').Func;
IMG.filtfunc = SCRPTGBL.CurrentTree.('Filterfunc').Func;
IMG.rcvcombfunc = SCRPTGBL.CurrentTree.('RcvCombfunc').Func;
IMG.pstpfunc = SCRPTGBL.CurrentTree.('PostProcfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FIDipt = SCRPTGBL.CurrentTree.('ImportFIDfunc');
if isfield(SCRPTGBL,('ImportFIDfunc_Data'))
    FIDipt.ImportFIDfunc_Data = SCRPTGBL.ImportFIDfunc_Data;
end
DCCORipt = SCRPTGBL.CurrentTree.('DCcorfunc');
if isfield(SCRPTGBL,('DCcorfunc_Data'))
    DCCORipt.DCcorfunc_Data = SCRPTGBL.DCcorfunc_Data;
end
PREPipt = SCRPTGBL.CurrentTree.('PreProcfunc');
if isfield(SCRPTGBL,('PreProcfunc_Data'))
    PREPipt.PreProcfunc_Data = SCRPTGBL.PreProcfunc_Data;
end
FILTipt = SCRPTGBL.CurrentTree.('Filterfunc');
if isfield(SCRPTGBL,('Filterfunc_Data'))
    FILTipt.Filterfunc_Data = SCRPTGBL.Filterfunc_Data;
end
RCOMBipt = SCRPTGBL.CurrentTree.('RcvCombfunc');
if isfield(SCRPTGBL,('RcvCombfunc_Data'))
    RCOMBipt.RcvCombfunc_Data = SCRPTGBL.RcvCombfunc_Data;
end
PSTPipt = SCRPTGBL.CurrentTree.('PostProcfunc');
if isfield(SCRPTGBL,('PostProcfunc_Data'))
    PSTPipt.PreProcfunc_Data = SCRPTGBL.PreProcfunc_Data;
end

%------------------------------------------
% Get FID Import Function Info
%------------------------------------------
func = str2func(IMG.importfidfunc);           
[SCRPTipt,FID,err] = func(SCRPTipt,FIDipt);
if err.flag
    return
end

%------------------------------------------
% Get DC correction Function Info
%------------------------------------------
func = str2func(IMG.dccorfunc);           
[SCRPTipt,DCCOR,err] = func(SCRPTipt,DCCORipt);
if err.flag
    return
end

%------------------------------------------
% Get Pre Processing Info
%------------------------------------------
func = str2func(IMG.prepfunc);           
[SCRPTipt,PREP,err] = func(SCRPTipt,PREPipt);
if err.flag
    return
end

%------------------------------------------
% Get Filter Info
%------------------------------------------
func = str2func(IMG.filtfunc);           
[SCRPTipt,FILT,err] = func(SCRPTipt,FILTipt);
if err.flag
    return
end

%------------------------------------------
% Get Image Create Function Info
%------------------------------------------
func = str2func(IMG.rcvcombfunc);           
[SCRPTipt,RCOMB,err] = func(SCRPTipt,RCOMBipt);
if err.flag
    return
end

%------------------------------------------
% Get Post Processing Info
%------------------------------------------
func = str2func(IMG.pstpfunc);           
[SCRPTipt,PSTP,err] = func(SCRPTipt,PSTPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.FID = FID;
INPUT.DCCOR = DCCOR;
INPUT.PREP = PREP;
INPUT.FILT = FILT;
INPUT.RCOMB = RCOMB;
INPUT.PSTP = PSTP;
[IMG,err] = func(INPUT,IMG);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
%set(findobj('tag','TestBox'),'string',IMG.ExpDisp);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
%SCRPTGBL.RWSUI.LocalOutput = IMG.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
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
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);



