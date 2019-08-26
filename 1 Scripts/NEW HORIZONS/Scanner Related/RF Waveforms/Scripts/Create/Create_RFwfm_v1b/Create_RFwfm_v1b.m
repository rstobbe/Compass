%====================================================
% (v1b)
%       
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Create_RFwfm_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Create RF Waveform');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('RF_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Load Input
%---------------------------------------------
RF.method = SCRPTGBL.CurrentTree.Func;
RF.crtefunc = SCRPTGBL.CurrentTree.('Createfunc').Func; 
RF.simfunc = SCRPTGBL.CurrentTree.('Simfunc').Func; 
RF.calcfunc = SCRPTGBL.CurrentTree.('Calcfunc').Func; 
RF.wrtfunc = SCRPTGBL.CurrentTree.('Wrtfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
CRTEipt = SCRPTGBL.CurrentTree.('Createfunc');
if isfield(SCRPTGBL,('Createfunc_Data'))
    CRTEipt.Createfunc_Data = SCRPTGBL.Createfunc_Data;
end
SIMipt = SCRPTGBL.CurrentTree.('Simfunc');
if isfield(SCRPTGBL,('Simfunc_Data'))
    SIMipt.Simfunc_Data = SCRPTGBL.Simfunc_Data;
end
CALCipt = SCRPTGBL.CurrentTree.('Calcfunc');
if isfield(SCRPTGBL,('Calcfunc_Data'))
    CALCipt.Calcfunc_Data = SCRPTGBL.Calcfunc_Data;
end
WRTipt = SCRPTGBL.CurrentTree.('Wrtfunc');
if isfield(SCRPTGBL,('Wrtfunc_Data'))
    WRTipt.Wrtfunc_Data = SCRPTGBL.Wrtfunc_Data;
end

%------------------------------------------
% Function Info
%------------------------------------------
func = str2func(RF.crtefunc);           
[SCRPTipt,CRTE,err] = func(SCRPTipt,CRTEipt);
if err.flag
    return
end
func = str2func(RF.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end
func = str2func(RF.calcfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end
func = str2func(RF.wrtfunc);           
[SCRPTipt,WRT,err] = func(SCRPTipt,WRTipt);
if err.flag
    return
end

%---------------------------------------------
% Create
%---------------------------------------------
func = str2func([RF.method,'_Func']);
INPUT.CRTE = CRTE;
INPUT.SIM = SIM;
INPUT.CALC = CALC;
INPUT.WRT = WRT;
[RF,err] = func(INPUT,RF);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
RF.ExpDisp = PanelStruct2Text(RF.PanelOutput);
set(findobj('tag','TestBox'),'string',RF.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Waveform:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('RF_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RF};
SCRPTGBL.RWSUI.SaveVariableNames = {'RF'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);



