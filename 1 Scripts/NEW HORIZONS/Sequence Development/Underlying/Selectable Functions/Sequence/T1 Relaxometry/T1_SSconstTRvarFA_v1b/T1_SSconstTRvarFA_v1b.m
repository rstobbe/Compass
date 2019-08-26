%=========================================================
% (v1b) 
%      - drop a level
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = T1_SSconstTRvarFA_v1b(SCRPTipt,SCRPTGBL)

Status('busy','T1 Relaxometry Test (Const TR - Variable FA)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Design_Name',{SCRPTipt.labelstr});
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
DES.method = SCRPTGBL.CurrentTree.Func;
DES.T1 = str2double(SCRPTGBL.CurrentTree.('T1_test'));
DES.TR = str2double(SCRPTGBL.CurrentTree.('TR'));
FlipArray = SCRPTGBL.CurrentTree.('FlipArray');
inds = strfind(FlipArray,',');
flip(1) = str2double(FlipArray(1:inds(1)-1));
for n = 2:length(inds)
    flip(n) = str2double(FlipArray(inds(n-1)+1:inds(n)-1));
end
flip(n+1) = str2double(FlipArray(inds(n)+1:end));
DES.FlipArray = flip;

%---------------------------------------------
% Run
%---------------------------------------------
func = str2func([DES.method,'_Func']);
INPUT = struct();
[DES,err] = func(DES,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = DES.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Study Design:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {DES};
SCRPTGBL.RWSUI.SaveVariableNames = {'DES'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};
