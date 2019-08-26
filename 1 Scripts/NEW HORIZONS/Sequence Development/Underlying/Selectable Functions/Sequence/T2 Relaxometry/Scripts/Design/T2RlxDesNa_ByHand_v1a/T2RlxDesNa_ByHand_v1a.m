%=========================================================
% (v1a) 
%       
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = T2RlxDesNa_ByHand_v1a(SCRPTipt,SCRPTGBL)

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
TEarr = SCRPTGBL.CurrentTree.('TEarr');

%---------------------------------------------
% TEarr
%---------------------------------------------
inds = strfind(TEarr,',');
RLXDES.TEarr(1) = str2double(TEarr(1:inds(1)-1));
for n = 2:length(inds)
    RLXDES.TEarr(n) = str2double(TEarr(inds(n-1)+1:inds(n)-1));
end
RLXDES.TEarr(n+1) = str2double(TEarr(inds(n)+1:length(TEarr)));

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
