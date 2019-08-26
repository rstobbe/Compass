%=====================================================
% (v1a) 
%           
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = CreateFromTrajUSL_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('GradTest_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            load(file);
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD.method = SCRPTGBL.CurrentTree.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
IMP.path = SCRPTGBL.('Imp_File_Data').path;
GRD.pregdur0 = str2double(SCRPTGBL.CurrentTree.('PreGDur'));
GRD.usetrajnum = str2double(SCRPTGBL.CurrentTree.('UseTrajNum'));
GRD.usetrajdir = SCRPTGBL.CurrentTree.('UseTrajDir');
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
INPUT.IMP = IMP;
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
SCRPTipt(strcmp('GradTest_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};

SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;

SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
