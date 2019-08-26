%=====================================================
% (v1a) 
%        
%=====================================================

function [SCRPTipt,SCRPTGBL,err] = Study_EmbeddedSpheres_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Embedded Sphere Study');
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
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Data_File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Data_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Input
%---------------------------------------------
ROIDEPEND.method = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
Data = SCRPTGBL.Data_File_Data;

%---------------------------------------------
% Build Study
%---------------------------------------------
func = str2func([ROIDEPEND.method,'_Func']);
INPUT.Data = Data;
[ROIDEPEND,err] = func(ROIDEPEND,INPUT);
if err.flag
    return
end
clear INPUT;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = ROIDEPEND.ExpDisp;

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
ROIDEPEND.name = name{1};
ROIDEPEND.structname = 'ROIDEPEND';

SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {ROIDEPEND};
SCRPTGBL.RWSUI.SaveVariableNames = {'ROIDEPEND'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
