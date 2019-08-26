%==================================================
% (v1b)
%     
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_StepResp_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot Transient Fields During/After Gradient');
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
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.clr = SCRPTGBL.CurrentTree.('Colour');
PLOT.type = SCRPTGBL.CurrentTree.('Type');
PLOT.GRD = SCRPTGBL.('GradDes_File_Data').GRD;

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
func = str2func([PLOT.method,'_Func']);
PLOT.EDDY = EDDY;
[OUTPUT,err] = func(PLOT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
