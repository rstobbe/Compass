%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = SodiumRegression_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Sodium Regression');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Study_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'DataFile_Excel_Data'))
    if isfield(SCRPTGBL.CurrentTree.('DataFile_Excel').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('DataFile_Excel').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load DataFile_Excel - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load DataFile_Excel');
            load(file);
            saveData.path = file;
            SCRPTGBL.('DataFile_Excel') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load DataFile_Excel';
        ErrDisp(err);
        return
    end
end


%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY.method = SCRPTGBL.CurrentTree.Func;
STUDY.buildexpfunc = SCRPTGBL.CurrentTree.('BuildExpfunc').Func;
STUDY.regressionfunc = SCRPTGBL.CurrentTree.('Regressionfunc').Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
STUDY.DataFile = SCRPTGBL.('DataFile_Excel_Data');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
BLDEXPipt = SCRPTGBL.CurrentTree.('BuildExpfunc');
if isfield(SCRPTGBL,('BuildExpfunc_Data'))
    BLDEXPipt.BuildExpfunc_Data = SCRPTGBL.BuildExpfunc_Data;
end
REGipt = SCRPTGBL.CurrentTree.('Regressionfunc');
if isfield(SCRPTGBL,('Regressionfunc_Data'))
    REGipt.Regressionfunc_Data = SCRPTGBL.Regressionfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(STUDY.buildexpfunc);           
[SCRPTipt,BLDEXP,err] = func(SCRPTipt,BLDEXPipt);
if err.flag
    return
end
func = str2func(STUDY.regressionfunc);           
[SCRPTipt,REG,err] = func(SCRPTipt,REGipt);
if err.flag
    return
end

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([STUDY.method,'_Func']);
INPUT.BLDEXP = BLDEXP;
INPUT.REG = REG;
[STUDY,err] = func(STUDY,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
STUDY.ExpDisp = PanelStruct2Text(STUDY.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = STUDY.ExpDisp;

%--------------------------------------------
% Name
%--------------------------------------------
name = 'STUDY_';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study:','Name',1,{name});
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
STUDY.name = name{1};
STUDY.structname = 'STUDY';

SCRPTipt(indnum).entrystr = STUDY.name;
SCRPTGBL.RWSUI.SaveVariables = STUDY;
SCRPTGBL.RWSUI.SaveVariableNames = 'STUDY';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = STUDY.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = STUDY.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
