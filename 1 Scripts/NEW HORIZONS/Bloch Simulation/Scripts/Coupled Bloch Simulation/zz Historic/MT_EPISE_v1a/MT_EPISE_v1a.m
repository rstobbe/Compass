%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MT_EPISE_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Simulate MT sequence with uses EPI');
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
SIMDES.script = SCRPTGBL.CurrentTree.Func;
SIMDES.relM0B = str2double(SCRPTGBL.CurrentTree.('relM0B'));
SIMDES.T1A = str2double(SCRPTGBL.CurrentTree.('T1A'));
SIMDES.T1B = str2double(SCRPTGBL.CurrentTree.('T1B'));
SIMDES.T2A = str2double(SCRPTGBL.CurrentTree.('T2A'));
SIMDES.T2B = str2double(SCRPTGBL.CurrentTree.('T2B'));
SIMDES.ExchgRate = str2double(SCRPTGBL.CurrentTree.('ExchgRate'));
SIMDES.satrffa = str2double(SCRPTGBL.CurrentTree.('SatRF_effFA'));
SIMDES.satrfwoff = str2double(SCRPTGBL.CurrentTree.('SatRF_woff'));
SIMDES.satrftau = str2double(SCRPTGBL.CurrentTree.('SatRF_tau'));
SIMDES.satrfrep = str2double(SCRPTGBL.CurrentTree.('SatRF_rep'));
SIMDES.TR = str2double(SCRPTGBL.CurrentTree.('TR'));
SIMDES.TE = str2double(SCRPTGBL.CurrentTree.('TE'));
SIMDES.linevalfunc = SCRPTGBL.CurrentTree.('LineShapeValfunc').Func;
SIMDES.coupledblochfunc = SCRPTGBL.CurrentTree.('CoupledBlochfunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
BLOCHipt = SCRPTGBL.CurrentTree.('CoupledBlochfunc');
if isfield(SCRPTGBL,('CoupledBlochfunc_Data'))
    BLOCHipt.CoupledBlochfunc_Data = SCRPTGBL.CoupledBlochfunc_Data;
end
LINEVALipt = SCRPTGBL.CurrentTree.('LineShapeValfunc');
if isfield(SCRPTGBL,('LineShapeValfunc_Data'))
    LINEVALipt.LineShapeValfunc_Data = SCRPTGBL.LineShapeValfunc_Data;
end

%------------------------------------------
% Bloch Excite Function Info
%------------------------------------------
func = str2func(SIMDES.coupledblochfunc);           
[SCRPTipt,BLOCH,err] = func(SCRPTipt,BLOCHipt);
if err.flag
    return
end

%------------------------------------------
% Line Shape Function Info
%------------------------------------------
func = str2func(SIMDES.linevalfunc);           
[SCRPTipt,LINEVAL,err] = func(SCRPTipt,LINEVALipt);
if err.flag
    return
end

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([SIMDES.script,'_Func']);
INPUT.BLOCH = BLOCH;
INPUT.LINEVAL = LINEVAL;
[SIMDES,err] = func(SIMDES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Sim:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Sim_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {SIMDES};
SCRPTGBL.RWSUI.SaveVariableNames = {'SIMDES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
