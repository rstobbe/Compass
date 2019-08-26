%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CNRopt_SpoiledSS_v1a(SCRPTipt,SCRPTGBL)

Status('busy','CNR optimization for spoiled steady state');
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
SIMDES.T1_A = str2double(SCRPTGBL.CurrentTree.('T1_A'));
SIMDES.T1_B = str2double(SCRPTGBL.CurrentTree.('T1_B'));
TR = SCRPTGBL.CurrentTree.('TR');
flip = SCRPTGBL.CurrentTree.('flip');


inds = strfind(TR,':');
if isempty(inds)
    SIMDES.TR = str2double(TR);
else
    start = str2double(TR(1:inds(1)-1));
    step = str2double(TR(inds(1)+1:inds(2)-1));
    stop = str2double(TR(inds(2)+1:length(TR))); 
    SIMDES.TR = (start:step:stop);
end
inds = strfind(flip,':');
if isempty(inds)
    SIMDES.flip = str2double(flip);
else
    start = str2double(flip(1:inds(1)-1));
    step = str2double(flip(inds(1)+1:inds(2)-1));
    stop = str2double(flip(inds(2)+1:length(flip))); 
    SIMDES.flip = (start:step:stop);
end

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
