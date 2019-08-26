%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Study_Analysis_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Study Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
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
if not(isfield(SCRPTGBL,'Study_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Study_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Study_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Study_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Study_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Study_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Study_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
STDYANLZ.method = SCRPTGBL.CurrentScript.Func;
STDYANLZ.analysisfunc = SCRPTGBL.CurrentTree.('Analysisfunc').Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
STUDY = SCRPTGBL.Study_File_Data.SBLD.STUDY;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ANLZipt = SCRPTGBL.CurrentTree.('Analysisfunc');
if isfield(SCRPTGBL,('Analysisfunc_Data'))
    ANLZipt.Analysisfunc_Data = SCRPTGBL.Analysisfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(STDYANLZ.analysisfunc);           
[SCRPTipt,ANLZ,err] = func(SCRPTipt,ANLZipt);
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([STDYANLZ.method,'_Func']);
INPUT.ANLZ = ANLZ;
INPUT.STUDY = STUDY;
[STDYANLZ,err] = func(STDYANLZ,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info(axnum).String = STDYANLZ.ExpDisp;
FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTab(axnum);
FIGOBJS.(SCRPTGBL.RWSUI.tab).UberTabGroup.SelectedTab = FIGOBJS.(tab).TopInfoTab;

%--------------------------------------------
% Name
%--------------------------------------------
auto = 0;
if auto == 0;
    name = inputdlg('Name Analysis:','Name Analysis',1,{'STDYANLZ_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {STDYANLZ};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
STDYANLZ.name = name;
STDYANLZ.path = IMG.path;
STDYANLZ.type = 'Image';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {STDYANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'STDYANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = IMG.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
