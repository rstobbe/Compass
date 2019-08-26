%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Create3DCart1_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create H1 3D Cartesian Image');
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
IMG.kdccorfunc = SCRPTGBL.CurrentTree.('kDCcorfunc').Func;
IMG.imdccorfunc = SCRPTGBL.CurrentTree.('imDCcorfunc').Func;
IMG.rcvcombfunc = SCRPTGBL.CurrentTree.('RcvCombfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FIDipt = SCRPTGBL.CurrentTree.('ImportFIDfunc');
if isfield(SCRPTGBL,('ImportFIDfunc_Data'))
    FIDipt.ImportFIDfunc_Data = SCRPTGBL.ImportFIDfunc_Data;
end
KDCCORipt = SCRPTGBL.CurrentTree.('kDCcorfunc');
if isfield(SCRPTGBL,('kDCcorfunc_Data'))
    KDCCORipt.kDCcorfunc_Data = SCRPTGBL.kDCcorfunc_Data;
end
IDCCORipt = SCRPTGBL.CurrentTree.('imDCcorfunc');
if isfield(SCRPTGBL,('imDCcorfunc_Data'))
    IDCCORipt.imDCcorfunc_Data = SCRPTGBL.imDCcorfunc_Data;
end
RCOMBipt = SCRPTGBL.CurrentTree.('RcvCombfunc');
if isfield(SCRPTGBL,('RcvCombfunc_Data'))
    RCOMBipt.RcvCombfunc_Data = SCRPTGBL.RcvCombfunc_Data;
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
func = str2func(IMG.kdccorfunc);           
[SCRPTipt,KDCCOR,err] = func(SCRPTipt,KDCCORipt);
if err.flag
    return
end

%------------------------------------------
% Get DC correction Function Info
%------------------------------------------
func = str2func(IMG.imdccorfunc);           
[SCRPTipt,IDCCOR,err] = func(SCRPTipt,IDCCORipt);
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

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.FID = FID;
INPUT.KDCCOR = KDCCOR;
INPUT.IDCCOR = IDCCOR;
INPUT.RCOMB = RCOMB;
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



