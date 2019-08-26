%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CombineSDC_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Combine SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('SDC_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Input
%---------------------------------------------
COMB.method = SCRPTGBL.CurrentScript.Func;
COMB.loadfunc = SCRPTGBL.CurrentTree.('LoadSDCfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('LoadSDCfunc');
if isfield(SCRPTGBL,('LoadSDCfunc_Data'))
    LOADipt.LoadSDCfunc_Data = SCRPTGBL.LoadSDCfunc_Data;
end

%------------------------------------------
% Get Load Function Info
%------------------------------------------
func = str2func(COMB.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
SDCS.SDCSarr = LOAD.SDCS;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
SDCS.ExpDisp = '';
set(findobj('tag','TestBox'),'string',SDCS.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name SDC:','Name SDC',1,{'SDC_'});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {SDCS};
SCRPTGBL.RWSUI.SaveVariableNames = 'SDCS';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
