%==============================================
% (v2a)
%       - 
%==============================================

function [SCRPTipt,SCRPTGBL,err] = TrajImpComp_v2a(SCRPTipt,SCRPTGBL)

Status('busy','Trajectory - Implementation Comparison');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Comp_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
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
COMP.method = SCRPTGBL.CurrentTree.Func;
COMP.trajnum = str2double(SCRPTGBL.CurrentTree.('TrajNum'));
COMP.trajortho = str2double(SCRPTGBL.CurrentTree.('TrajOrtho'));
COMP.graddel = str2double(SCRPTGBL.CurrentTree.('GradDel'));
COMP.gpol = SCRPTGBL.CurrentTree.('Polarity');
GRD = SCRPTGBL.('GradTest_File_Data').GRD;
EDDY = SCRPTGBL.('Data_File_Data').EDDY;

%-----------------------------------------------------
% Perform Regression
%-----------------------------------------------------
func = str2func([COMP.method,'_Func']);
INPUT.EDDY = EDDY;
INPUT.GRD = GRD;
[COMP,err] = func(COMP,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
%SCRPTGBL.RWSUI.LocalOutput = COMP.PanelOutput;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%COMP.ExpDisp = PanelStruct2Text(COMP.PanelOutput);
%set(findobj('tag','TestBox'),'string',COMP.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Eddy Current Comparison:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {COMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'COMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

