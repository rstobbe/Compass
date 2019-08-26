%=========================================================
% (v2a)
%   - Move TrajSampfunc and ProjSampfunc below
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Implement_Proj3D_v2a(SCRPTipt,SCRPTGBL)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

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
            Status('busy','Load Trajectory Implementation');
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
% Load Input
%---------------------------------------------
IMP.method = SCRPTGBL.CurrentTree.Func;
IMP.testfunc = SCRPTGBL.CurrentTree.('TrajTestfunc').Func;
IMP.nucfunc = SCRPTGBL.CurrentTree.('Nucfunc').Func;
IMP.sysfunc = SCRPTGBL.CurrentTree.('Sysfunc').Func;
IMP.impmethfunc = SCRPTGBL.CurrentTree.('ImpMethfunc').Func;

%---------------------------------------------
% Get Trajectory Design
%---------------------------------------------
DES = SCRPTGBL.Des_File_Data.DES;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
TSTipt = SCRPTGBL.CurrentTree.('TrajTestfunc');
if isfield(SCRPTGBL,('TrajTest_Data'))
    TSTipt.TrajTest_Data = SCRPTGBL.TrajTest_Data;
end
NUCipt = SCRPTGBL.CurrentTree.('Nucfunc');
if isfield(SCRPTGBL,('Nucfunc_Data'))
    NUCipt.Nucfunc_Data = SCRPTGBL.Nucfunc_Data;
end
SYSipt = SCRPTGBL.CurrentTree.('Sysfunc');
if isfield(SCRPTGBL,('Sysfunc_Data'))
    SYSipt.Sysfunc_Data = SCRPTGBL.Sysfunc_Data;
end
IMETHipt = SCRPTGBL.CurrentTree.('ImpMethfunc');  
if isfield(SCRPTGBL,('ImpMethfunc_Data'))
    IMETHipt.ImpMethfunc_Data = SCRPTGBL.ImpMethfunc_Data;
end

%------------------------------------------
% Get Testing Info
%------------------------------------------
func = str2func(IMP.testfunc);           
[SCRPTipt,TST,err] = func(SCRPTipt,TSTipt);
if err.flag
    return
end

%------------------------------------------
% Get Nucleus Info
%------------------------------------------
func = str2func(IMP.nucfunc);           
[SCRPTipt,NUC,err] = func(SCRPTipt,NUCipt);
if err.flag
    return
end

%------------------------------------------
% Get System Implementation Function Info
%------------------------------------------
func = str2func(IMP.sysfunc);           
[SCRPTipt,SYS,err] = func(SCRPTipt,SYSipt);
if err.flag
    return
end

%------------------------------------------
% Get Vector Quantization Function Info
%------------------------------------------
func = str2func(IMP.impmethfunc);           
[SCRPTipt,IMETH,err] = func(SCRPTipt,IMETHipt);
if err.flag
    return
end

%---------------------------------------------
% Implement Design
%---------------------------------------------
func = str2func([IMP.method,'_Func']);
INPUT.DES = DES;
INPUT.TST = TST;
INPUT.NUC = NUC;
INPUT.SYS = SYS;
INPUT.IMETH = IMETH;
[IMP,err] = func(INPUT,IMP);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
Text = [char(10) PanelStruct2Text(IMP.DesPanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.SYS.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.GWFM.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.PSMP.PanelOutput)];
Text = [Text char(10) PanelStruct2Text(IMP.TSMP.PanelOutput)];
IMP.ExpDisp = [Text char(10) PanelStruct2Text(IMP.KSMP.PanelOutput)];
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMP.ExpDisp;

%--------------------------------------------
% Finish Output Structure
%--------------------------------------------
IMP.DES = DES;

%--------------------------------------------
% Name
%--------------------------------------------
name = ['IMP_',DES.name(5:end)];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Implementation:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
IMP.name = name{1};

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {IMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

