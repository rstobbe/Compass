%==================================================
% (v1a)
%       
%==================================================

function [SCRPTipt,SCRPTGBL,err] = ExportB0Resp_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Export B0 Resp');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get EDDY Currents
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No EDDY in Global Memory';
    return  
end
EDDY = TOTALGBL{2,val};

%-----------------------------------------------------
% Test
%-----------------------------------------------------
if not(isfield(EDDY,'Geddy'))
    err.flag = 1;
    err.msg = 'Global does not contain eddy currents';
    return
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradDes_File_Data'))
    file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    else
        Status('busy','Load Gradient Design');
        load(file);
        saveData.path = file;
        SCRPTGBL.('GradDes_File_Data') = saveData;
    end
end

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
EXPORT.method = SCRPTGBL.CurrentTree.Func;
EXPORT.B0start = str2double(SCRPTGBL.CurrentTree.('B0start'));
EXPORT.B0stop = str2double(SCRPTGBL.CurrentTree.('B0stop'));
EXPORT.slpmid = str2double(SCRPTGBL.CurrentTree.('slpmid'));
EXPORT.GRD = SCRPTGBL.('GradDes_File_Data').GRD;

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
func = str2func([EXPORT.method,'_Func']);
INPUT.EDDY = EDDY;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end
clear INPUT
B0RESP = EXPORT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name B0 Response:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('B0Resp_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {B0RESP};
SCRPTGBL.RWSUI.SaveVariableNames = {'B0RESP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

