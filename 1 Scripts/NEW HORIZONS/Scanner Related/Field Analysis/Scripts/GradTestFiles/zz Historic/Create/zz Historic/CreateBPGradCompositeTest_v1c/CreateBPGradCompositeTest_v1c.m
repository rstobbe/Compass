%=====================================================
% (v1c) 
%       - start 'CreateMultiBPGradsUSL_v1c'
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateBPGradCompositeTest_v1c(SCRPTipt,SCRPTGBL)

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
GRD.method = SCRPTGBL.CurrentTree.Func;
GRD.numbgtests = str2double(SCRPTGBL.CurrentTree.('NumBGtests'));
GRD.numpltests = str2double(SCRPTGBL.CurrentTree.('NumPLtests'));
GRD.plgrad = str2double(SCRPTGBL.CurrentTree.('PLGrad'));
GRD.totgraddur0 = str2double(SCRPTGBL.CurrentTree.('TotGradDur'));
GRD.pregdur0 = str2double(SCRPTGBL.CurrentTree.('PreGDur'));
GRD.gatmaxdur0 = str2double(SCRPTGBL.CurrentTree.('GatMaxDur'));
GRD.intergdur0 = str2double(SCRPTGBL.CurrentTree.('InterGDur'));
GRD.gstepdur = str2double(SCRPTGBL.CurrentTree.('GStepDur'));
GRD.gsl = str2double(SCRPTGBL.CurrentTree.('Gsl'));
GRD.gstart = str2double(SCRPTGBL.CurrentTree.('Gstart'));
GRD.gstep = str2double(SCRPTGBL.CurrentTree.('Gstep'));
GRD.gstop = str2double(SCRPTGBL.CurrentTree.('Gstop'));
GRD.syswrtfunc = SCRPTGBL.CurrentTree.('SysWrtfunc').Func; 
GRD.testsampfunc = SCRPTGBL.CurrentTree.('TestSampfunc').Func; 

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SYSWRTipt = SCRPTGBL.CurrentTree.('SysWrtfunc');
if isfield(SCRPTGBL,('SysWrtfunc_Data'))
    SYSWRTipt.SysWrtfunc_Data = SCRPTGBL.SysWrtfunc_Data;
end
TSAMPipt = SCRPTGBL.CurrentTree.('TestSampfunc');
if isfield(SCRPTGBL,('TestSampfunc_Data'))
    TSAMPipt.TestSampfunc_Data = SCRPTGBL.TestSampfunc_Data;
end

%------------------------------------------
% Get Write Parameter Function Info
%------------------------------------------
func = str2func(GRD.syswrtfunc);           
[SCRPTipt,SYSWRT,err] = func(SCRPTipt,SYSWRTipt);
if err.flag
    return
end
func = str2func(GRD.testsampfunc);           
[SCRPTipt,TSAMP,err] = func(SCRPTipt,TSAMPipt);
if err.flag
    return
end

%---------------------------------------------
% Create Gradients
%---------------------------------------------
func = str2func([GRD.method,'_Func']);
INPUT.SYSWRT = SYSWRT;
INPUT.TSAMP = TSAMP;
[GRD,err] = func(GRD,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gradient File:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('GradSet_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
