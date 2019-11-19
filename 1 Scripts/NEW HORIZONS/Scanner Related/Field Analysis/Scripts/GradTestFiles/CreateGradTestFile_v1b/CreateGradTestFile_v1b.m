%=====================================================
% (v1b) 
%     - general update (include Figures)
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateGradTestFile_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Get Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('GradSet_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP.method = SCRPTGBL.CurrentTree.Func;
IMP.syswrtfunc = SCRPTGBL.CurrentTree.('SysWrtfunc').Func; 
IMP.testsampfunc = SCRPTGBL.CurrentTree.('TestSampfunc').Func; 
IMP.testdesfunc = SCRPTGBL.CurrentTree.('TestDesfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SYSWRTipt = SCRPTGBL.CurrentTree.('SysWrtfunc');
if isfield(SCRPTGBL,('SysWrtfunc_Data'))
    SYSWRTipt.SysWrtfunc_Data = SCRPTGBL.SysWrtfunc_Data;
end
GTSAMPipt = SCRPTGBL.CurrentTree.('TestSampfunc');
if isfield(SCRPTGBL,('TestSampfunc_Data'))
    GTSAMPipt.TestSampfunc_Data = SCRPTGBL.TestSampfunc_Data;
end
GTDESipt = SCRPTGBL.CurrentTree.('TestDesfunc');
if isfield(SCRPTGBL,('TestDesfunc_Data'))
    GTDESipt.TestDesfunc_Data = SCRPTGBL.TestDesfunc_Data;
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(IMP.syswrtfunc);           
[SCRPTipt,SYSWRT,err] = func(SCRPTipt,SYSWRTipt);
if err.flag
    return
end
func = str2func(IMP.testsampfunc);           
[SCRPTipt,GTSAMP,err] = func(SCRPTipt,GTSAMPipt);
if err.flag
    return
end
func = str2func(IMP.testdesfunc);           
[SCRPTipt,SCRPTGBL,GTDES,err] = func(SCRPTipt,SCRPTGBL,GTDESipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([IMP.method,'_Func']);
INPUT.SYSWRT = SYSWRT;
INPUT.GTSAMP = GTSAMP;
INPUT.GTDES = GTDES;
[IMP,err] = func(IMP,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
IMP.ExpDisp = PanelStruct2Text(IMP.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = IMP.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:','Name',1,{['IMP_',IMP.name]});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
IMP.name = name{1};

SCRPTipt(indnum).entrystr = IMP.name;
SCRPTGBL.RWSUI.SaveVariables = IMP;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = IMP.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = IMP.path;
SCRPTGBL.RWSUI.SaveScriptName = IMP.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

