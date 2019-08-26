%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = MzLossSingleRF_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Analysis of Mz Loss During Single RF pulse');
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
SIMDES.T1 = str2double(SCRPTGBL.CurrentTree.('T1'));
SIMDES.T2 = str2double(SCRPTGBL.CurrentTree.('T2'));
SIMDES.w1 = str2double(SCRPTGBL.CurrentTree.('w1'));
SIMDES.woff = str2double(SCRPTGBL.CurrentTree.('woff'));
SIMDES.tauRF = str2double(SCRPTGBL.CurrentTree.('tauRF'));
SIMDES.blochexcitefunc = SCRPTGBL.CurrentTree.('BlochExcitefunc').Func;

%---------------------------------------------
% Get Working Structures
%---------------------------------------------
BLOCHEXipt = SCRPTGBL.CurrentTree.('BlochExcitefunc');
if isfield(SCRPTGBL,('BlochExcitefunc_Data'))
    BLOCHEXipt.BlochExcitefunc_Data = SCRPTGBL.BlochExcitefunc_Data;
end

%------------------------------------------
% Bloch Excite Function Info
%------------------------------------------
func = str2func(SIMDES.blochexcitefunc);           
[SCRPTipt,BLOCHEX,err] = func(SCRPTipt,BLOCHEXipt);
if err.flag
    return
end

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([SIMDES.script,'_Func']);
INPUT.BLOCHEX = BLOCHEX;
[SIMDES,err] = func(SIMDES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name RlxDes:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('RlxDes_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

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
