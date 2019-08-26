%==================================
% 
%==================================

function [SCRPTipt,SCRPTGBL,err] = GenModelFitting_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Genearl Model Fitting');
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
    if isfield(SCRPTGBL.CurrentTree.('GradDes_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('GradDes_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDes_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('GradDes_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDes_File';
        ErrDisp(err);
        return
    end
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.GRD = SCRPTGBL.('GradDes_File_Data').GRD;

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([RGRS.method,'_Func']);
INPUT.EDDY = EDDY;
[RGRS,err] = func(RGRS,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
SCRPTGBL.RWSUI.LocalOutput = RGRS.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Regression:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Rgrs_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RGRS};
SCRPTGBL.RWSUI.SaveVariableNames = {'RGRS'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

