%==============================================
% (v2a)
%       - 
%==============================================

function [SCRPTipt,SCRPTGBL,err] = Plot_TrajTest_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Plot Trajectory Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Plot_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'GradTest_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('GradTest_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('GradTest_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradTest_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('GradTest_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradTest_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Data_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Data_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Data_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Data_File';
            ErrDisp(err);
            return
        else
            SCRPTGBL.('Data_File_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Data_File';
        ErrDisp(err);
        return
    end
end


%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
PLOT.method = SCRPTGBL.CurrentTree.Func;
PLOT.graddel = str2double(SCRPTGBL.CurrentTree.('GradDel'));
PLOT.gpol = SCRPTGBL.CurrentTree.('Polarity');
GRD = SCRPTGBL.('GradTest_File_Data').GRD;
EDDY = SCRPTGBL.('Data_File_Data').EDDY;

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([PLOT.method,'_Func']);
INPUT.EDDY = EDDY;
INPUT.GRD = GRD;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
%SCRPTGBL.RWSUI.LocalOutput = PLOT.PanelOutput;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%PLOT.ExpDisp = PanelStruct2Text(PLOT.PanelOutput);
%set(findobj('tag','TestBox'),'string',PLOT.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Comparison:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {PLOT};
SCRPTGBL.RWSUI.SaveVariableNames = {'PLOT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

