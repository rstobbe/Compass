%=========================================================
% (v1e)
%   - update for split 
%   - saving testing allowed
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = TPI_INOVA_v1e(SCRPTipt,SCRPTGBL)

Status('busy','Implement Trajectory Design');
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
PROJimp.system = SCRPTGBL.CurrentTree.('System');
PROJimp.nucleus = SCRPTGBL.CurrentTree.('Nucleus');
if strcmp(PROJimp.nucleus,'1H')
    PROJimp.gamma = 42.577;
elseif strcmp(PROJimp.nucleus,'23Na')
    PROJimp.gamma = 11.26;
end
PROJimp.slvno = str2double(SCRPTGBL.CurrentTree.('SlvNo'));
PROJimp.orient = SCRPTGBL.CurrentTree.('Orient');
PROJimp.sysimpfunc = SCRPTGBL.CurrentTree.('SysImpfunc').Func;
PROJimp.qvecslvfunc = SCRPTGBL.CurrentTree.('QVecSlvfunc').Func;
PROJimp.gwfmfunc = SCRPTGBL.CurrentTree.('GWFMfunc').Func;
PROJimp.psmpfunc = SCRPTGBL.CurrentTree.('ProjSampfunc').Func;
PROJimp.tsmpfunc = SCRPTGBL.CurrentTree.('TrajSampfunc').Func;
PROJimp.ksmpfunc = SCRPTGBL.CurrentTree.('kSampfunc').Func;

%---------------------------------------------
% Get Testing Info
%---------------------------------------------
testingonly = SCRPTGBL.CurrentTree.('Testing_Only');

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
DES = SCRPTGBL.Des_File_Data.DES;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SYSipt = SCRPTGBL.CurrentTree.('SysImpfunc');
if isfield(SCRPTGBL,('SysImpfunc_Data'))
    SYSipt.SysImpfunc_Data = SCRPTGBL.SysImpfunc_Data;
end
GQNTipt = SCRPTGBL.CurrentTree.('QVecSlvfunc');  
if isfield(SCRPTGBL,('QVecSlvfunc_Data'))
    GQNTipt.QVecSlvfunc_Data = SCRPTGBL.QVecSlvfunc_Data;
end
GWFMipt = SCRPTGBL.CurrentTree.('GWFMfunc');
if isfield(SCRPTGBL,('GWFMfunc_Data'))
    GWFMipt.GWFMfunc_Data = SCRPTGBL.GWFMfunc_Data;
end
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
    KSMPipt.kSampfunc_Data = SCRPTGBL.kSampfunc_Data;
end

%------------------------------------------
% Get System Implementation Function Info
%------------------------------------------
func = str2func(PROJimp.sysimpfunc);           
[SCRPTipt,SYS,err] = func(SCRPTipt,SYSipt);
if err.flag
    return
end

%------------------------------------------
% Get Vector Quantization Function Info
%------------------------------------------
func = str2func(PROJimp.qvecslvfunc);           
[SCRPTipt,GQNT,err] = func(SCRPTipt,GQNTipt);
if err.flag
    return
end

%------------------------------------------
% Get Gradient Waveform Function Info
%------------------------------------------
func = str2func(PROJimp.gwfmfunc);           
[SCRPTipt,GWFM,err] = func(SCRPTipt,GWFMipt);
if err.flag
    return
end

%------------------------------------------
% Get Projection Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.psmpfunc);           
[SCRPTipt,PSMP,err] = func(SCRPTipt,PSMPipt);
if err.flag
    return
end

%------------------------------------------
% Get Trajecory Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.tsmpfunc);           
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
if err.flag
    return
end

%------------------------------------------
% Get k-Space Sampling Function Info
%------------------------------------------
func = str2func(PROJimp.ksmpfunc);           
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
INPUT.SYS = SYS;
INPUT.GQNT = GQNT;
INPUT.GWFM = GWFM;
INPUT.PSMP = PSMP;
INPUT.TSMP = TSMP;
INPUT.KSMP = KSMP;
INPUT.testingonly = testingonly;
[IMP,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
Text = PanelStruct2Text(IMP.SYS.PanelOutput);
Text = [Text char(10) PanelStruct2Text(IMP.GQNT.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.GWFM.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.PSMP.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.TSMP.PanelOutput)];
IMP.ExpDisp = [Text char(10) PanelStruct2Text(IMP.KSMP.PanelOutput)];
set(findobj('tag','TestBox'),'string',IMP.ExpDisp);

%--------------------------------------------
% Finish Output Structure
%--------------------------------------------
IMP.DES = DES;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Implementation:','Name',1,{'IMP_'});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Imp_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);
SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'ProjImp';

Status('done','');
Status2('done','',2);
Status2('done','',3);