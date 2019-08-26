%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MTsimulation_v1a(SCRPTipt,SCRPTGBL)

Status('busy','MT simulation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Sim_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
MTSIM.script = SCRPTGBL.CurrentTree.Func;
MTSIM.relM0B = str2double(SCRPTGBL.CurrentTree.('relM0B'));
MTSIM.T1A = str2double(SCRPTGBL.CurrentTree.('T1A'));
MTSIM.T1B = str2double(SCRPTGBL.CurrentTree.('T1B'));
MTSIM.T2A = str2double(SCRPTGBL.CurrentTree.('T2A'));
MTSIM.T2B = str2double(SCRPTGBL.CurrentTree.('T2B'));
MTSIM.ExchgRate = str2double(SCRPTGBL.CurrentTree.('ExchgRate'));
MTSIM.seqsimfunc = SCRPTGBL.CurrentTree.('SeqSimfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
SEQSIMipt = SCRPTGBL.CurrentTree.('SeqSimfunc');
if isfield(SCRPTGBL,('SeqSimfunc_Data'))
    SEQSIMipt.SeqSimfunc_Data = SCRPTGBL.SeqSimfunc_Data;
end

%------------------------------------------
% Bloch Excite Function Info
%------------------------------------------
func = str2func(MTSIM.seqsimfunc);           
[SCRPTipt,SEQSIM,err] = func(SCRPTipt,SEQSIMipt);
if err.flag
    return
end

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([MTSIM.script,'_Func']);
INPUT.SEQSIM = SEQSIM;
[MTSIM,err] = func(MTSIM,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
MTSIM.ExpDisp = PanelStruct2Text(MTSIM.PanelOutput);
set(findobj('tag','TestBox'),'string',MTSIM.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Sim:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Sim_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {MTSIM};
SCRPTGBL.RWSUI.SaveVariableNames = {'MTSIM'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
