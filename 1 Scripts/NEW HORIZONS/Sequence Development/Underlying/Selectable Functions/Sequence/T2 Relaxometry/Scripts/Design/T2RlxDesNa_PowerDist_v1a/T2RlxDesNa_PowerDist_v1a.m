%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = T2RlxDesNa_PowerDist_v1a(SCRPTipt,SCRPTGBL)

Status('busy','T2 Relaxometry Study Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('RlxDes_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
RLXDES.script = SCRPTGBL.CurrentTree.Func;
RLXDES.T2f = str2double(SCRPTGBL.CurrentTree.('T2f'));
RLXDES.T2s = str2double(SCRPTGBL.CurrentTree.('T2s'));
RLXDES.TEmin = str2double(SCRPTGBL.CurrentTree.('TEmin'));
RLXDES.TEmax = str2double(SCRPTGBL.CurrentTree.('TEmax'));
RLXDES.Power = str2double(SCRPTGBL.CurrentTree.('Power'));
SMNR = (SCRPTGBL.CurrentTree.('SMNR'));
N = (SCRPTGBL.CurrentTree.('N'));
RLXDES.MonteCarlo = str2double(SCRPTGBL.CurrentTree.('MonteCarlo'));

%---------------------------------------------
% SMNR
%---------------------------------------------
inds = strfind(SMNR,':');
RLXDES.smnrmin = str2double(SMNR(1:inds(1)-1));
RLXDES.smnrstep = str2double(SMNR(inds(1)+1:inds(2)-1));
RLXDES.smnrmax = str2double(SMNR(inds(2)+1:length(SMNR))); 

%---------------------------------------------
% N
%---------------------------------------------
inds = strfind(N,',');
RLXDES.Nmin = str2double(N(1:inds(1)-1));
RLXDES.Nmax = str2double(N(inds(1)+1:length(N))); 

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([RLXDES.script,'_Func']);
INPUT = struct();
[RLXDES,err] = func(RLXDES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Display
%--------------------------------------------


%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name RlxDes:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('RlxDes_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {RLXDES};
SCRPTGBL.RWSUI.SaveVariableNames = {'RLXDES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
