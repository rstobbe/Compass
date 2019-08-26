%====================================================
% (v1b)
%       - Start with 'EddyCurrents_v1b'
%====================================================

function [SCRPTipt,SCRPTGBL,err] = GradStepResp_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Determine Gradient Step Response ');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('StepResp_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SR.method = SCRPTGBL.CurrentTree.Func;
SR.Sys = SCRPTGBL.CurrentTree.('System');
SR.B0cal = str2double(SCRPTGBL.CurrentTree.('B0'));
SR.Gcal = str2double(SCRPTGBL.CurrentTree.('G'));
SR.psbgfunc = SCRPTGBL.CurrentTree.('PosBgrndfunc').Func;
SR.tffunc = SCRPTGBL.CurrentTree.('TransFieldfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
POSBGipt = SCRPTGBL.CurrentTree.('PosBgrndfunc');
if isfield(SCRPTGBL,('PosBgrndfunc_Data'))
    POSBGipt.PosBgrndfunc_Data = SCRPTGBL.PosBgrndfunc_Data;
end
TFipt = SCRPTGBL.CurrentTree.('TransFieldfunc');
if isfield(SCRPTGBL,('TransFieldfunc_Data'))
    TFipt.TransFieldfunc_Data = SCRPTGBL.TransFieldfunc_Data;
end

%------------------------------------------
% Position and BackGround Function Info
%------------------------------------------
func = str2func(SR.psbgfunc);           
[SCRPTipt,POSBG,err] = func(SCRPTipt,POSBGipt);
if err.flag
    return
end

%------------------------------------------
% Transient Field Function Info
%------------------------------------------
func = str2func(SR.tffunc);           
[SCRPTipt,TF,err] = func(SCRPTipt,TFipt);
if err.flag
    return
end

%---------------------------------------------
% Find Step Response
%---------------------------------------------
func = str2func([SR.method,'_Func']);
INPUT.POSBG = POSBG;
INPUT.TF = TF;
[SR,err] = func(SR,INPUT);
if err.flag
    return
end

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
set(findobj('tag','TestBox'),'string',SR.ExpDisp);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
SCRPTGBL.RWSUI.LocalOutput = SR.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Step Response:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SR};
SCRPTGBL.RWSUI.SaveVariableNames = {'SR'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

Status('done','');
Status2('done','',2);
Status2('done','',3);

