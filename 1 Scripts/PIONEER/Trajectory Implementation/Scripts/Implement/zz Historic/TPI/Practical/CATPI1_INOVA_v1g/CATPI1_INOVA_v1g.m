%=========================================================
% (CATPI1)
%   - iSeg specification
% (v1g)
%   - output update only
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CATPI1_INOVA_v1g(SCRPTipt,SCRPTGBL)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Des_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Des_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Des_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Des_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Deslementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Des_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Des_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Imp_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJimp.method = SCRPTGBL.CurrentTree.Func;
PROJimp.system = 'Varian Inova';
PROJimp.nucleus = SCRPTGBL.CurrentTree.('Nucleus');
if strcmp(PROJimp.nucleus,'1H')
    PROJimp.gamma = 42.577;
elseif strcmp(PROJimp.nucleus,'23Na')
    PROJimp.gamma = 11.26;
end
PROJimp.slvno = str2double(SCRPTGBL.CurrentTree.('SlvNo'));
PROJimp.orient = SCRPTGBL.CurrentTree.('Orient');
PROJimp.iseg = str2double(SCRPTGBL.CurrentTree.('iSeg'));
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
% Implement Design
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
% Name
%--------------------------------------------
name = inputdlg('Name Implementation:','Name',1,{'IMP_'});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%--------------------------------------------
% Output
%--------------------------------------------
SCRPTipt(indnum).entrystr = cell2mat(name);
SCRPTGBL.RWSUI.SaveVariables = IMP;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = cell2mat(name);
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

