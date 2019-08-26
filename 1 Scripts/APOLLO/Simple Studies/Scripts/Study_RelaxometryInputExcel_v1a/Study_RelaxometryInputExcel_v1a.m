%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = Study_RelaxometryInputExcel_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Relaxometry Study');
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
if not(isfield(SCRPTGBL,'ExcelFile_Data'))
    if isfield(SCRPTGBL.CurrentTree.('ExcelFile').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('ExcelFile').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ExcelFile - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load ExcelFile');
            load(file);
            saveData.path = file;
            SCRPTGBL.('ExcelFile_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ExcelFile';
        ErrDisp(err);
        return
    end
end


%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY.method = SCRPTGBL.CurrentTree.Func;
STUDY.analysisfunc = SCRPTGBL.CurrentTree.('Analysisfunc').Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
Data = SCRPTGBL.ExcelFile_Data;

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
func = str2func(STUDY.analysisfunc);           
[SCRPTipt,ANLZ,err] = func(SCRPTipt,ANLZipt);
if err.flag
    return
end

%---------------------------------------------
% Build Study
%---------------------------------------------
func = str2func([STUDY.method,'_Func']);
INPUT.ANLZ = ANLZ;
INPUT.Data = Data;
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
name = ['STUDY_',STUDY.Name];

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

SCRPTipt(indnum).entrystr = name{1};
SCRPTGBL.RWSUI.SaveVariables = STUDY;
SCRPTGBL.RWSUI.SaveVariableNames = 'STUDY';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name{1};
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

Status('done','');
Status2('done','',2);
Status2('done','',3);
