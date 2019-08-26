%==================================
% 
%==================================

function [SCRPTipt,SCRPTGBL,err] = MultiExp_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Eddy Current Regression Info');
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

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
RGRS.method = SCRPTGBL.CurrentTree.Func;
RGRS.figno = str2double(SCRPTGBL.CurrentTree.('Figure_Number'));
RGRS.seleddy = SCRPTGBL.CurrentTree.('SelectEddy');
RGRS.nexps = str2double(SCRPTGBL.CurrentTree.('Number_Exps'));
RGRS.datastart = str2double(SCRPTGBL.CurrentTree.('DataStart'));
RGRS.datastop = str2double(SCRPTGBL.CurrentTree.('DataStop'));
RGRS.timepastg = SCRPTGBL.CurrentTree.('TimePastG');
RGRS.tcest = str2double(SCRPTGBL.CurrentTree.('Tc_Estimate'));

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',EDDY.ExpDisp);

%-----------------------------------------------------
% Test for B0 Viability
%-----------------------------------------------------
Params = EDDY.TF.Params;
if strcmp(Params.graddir,Params.position)
    goodB0 = 1;
else
    goodB0 = 0;
end
if strcmp(RGRS.seleddy,'B0eddy') && goodB0 == 0
    err.flag = 1;
    err.msg = 'Experiment not compatible with B0 measurement';
    return
end

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

