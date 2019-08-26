%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Anlz_SpoiledSS_v1a(SCRPTipt,SCRPTGBL)

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
SIMDES.T1 = str2double(SCRPTGBL.CurrentTree.('T1'));
SIMDES.T2 = str2double(SCRPTGBL.CurrentTree.('T2'));
SIMDES.TR = str2double(SCRPTGBL.CurrentTree.('TR'));
SIMDES.flip = str2double(SCRPTGBL.CurrentTree.('flip'));

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([SIMDES.script,'_Func']);
INPUT = '';
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
