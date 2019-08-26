%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateH1Cart3D_v1a(SCRPTipt,SCRPTGBL)

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
IMG.importfidfunc = SCRPTGBL.CurrentTree.ImportFIDfunc.Func;
IMG.dccorfunc = SCRPTGBL.CurrentTree.DCcorfunc.Func;
IMG.imagecreatefunc = SCRPTGBL.CurrentTree.CreateImagefunc.Func;
IMG.orient = SCRPTGBL.CurrentTree.('Orient');
IMG.testplots = SCRPTGBL.CurrentTree.('TestPlots');

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
ICipt = SCRPTGBL.CurrentTree.('CreateImagefunc');
if isfield(SCRPTGBL,('CreateImagefunc_Data'))
    ICipt.CreateImagefunc_Data = SCRPTGBL.CreateImagefunc_Data;
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
INPUT.FID = FID;
INPUT.DCCOR = DCCOR;
INPUT.IMG = IMG;
INPUT.IC = IC;
[IMG,err] = func(INPUT);
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



