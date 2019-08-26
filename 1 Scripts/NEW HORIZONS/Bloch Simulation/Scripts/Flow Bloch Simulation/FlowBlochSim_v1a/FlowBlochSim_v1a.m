%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = FlowBlochSim_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Flow Bloch simulation');
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
BLSIM.script = SCRPTGBL.CurrentTree.Func;
BLSIM.T1 = str2double(SCRPTGBL.CurrentTree.('T1'));
BLSIM.T2 = str2double(SCRPTGBL.CurrentTree.('T2'));
BLSIM.vel = str2double(SCRPTGBL.CurrentTree.('FlowRate'));
BLSIM.seqsimfunc = SCRPTGBL.CurrentTree.('SeqSimfunc').Func;

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
func = str2func(BLSIM.seqsimfunc);           
[SCRPTipt,SEQSIM,err] = func(SCRPTipt,SEQSIMipt);
if err.flag
    return
end

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([BLSIM.script,'_Func']);
INPUT.SEQSIM = SEQSIM;
[BLSIM,err] = func(BLSIM,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
BLSIM.ExpDisp = PanelStruct2Text(BLSIM.PanelOutput);
set(findobj('tag','TestBox'),'string',BLSIM.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Sim:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    Status('done','');
    Status2('done','',2);
    Status2('done','',3);
    return
end
SCRPTipt(strcmp('Sim_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {BLSIM};
SCRPTGBL.RWSUI.SaveVariableNames = {'BLSIM'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
