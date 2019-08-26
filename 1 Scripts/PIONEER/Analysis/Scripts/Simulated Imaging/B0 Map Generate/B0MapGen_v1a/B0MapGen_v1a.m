%===========================================
% (v1a)
%       
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B0MapGen_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create a B0 Map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Map_Name',{SCRPTipt.labelstr});
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
B0GEN.method = SCRPTGBL.CurrentTree.Func;
B0GEN.B0MapFunc = SCRPTGBL.CurrentTree.('B0Mapfunc').Func;
B0GEN.ObMatSz = str2double(SCRPTGBL.CurrentTree.('ObMatSz'));
B0GEN.SampFoV = str2double(SCRPTGBL.CurrentTree.('SampFoV'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
B0MAPipt = SCRPTGBL.CurrentTree.('B0Mapfunc');
if isfield(SCRPTGBL,('B0Mapfunc_Data'))
    B0MAPipt.B0Mapfunc_Data = SCRPTGBL.B0Mapfunc_Data;
end

%------------------------------------------
% Get Map Function Info
%------------------------------------------
func = str2func(B0GEN.B0MapFunc);           
[SCRPTipt,B0MAP,err] = func(SCRPTipt,B0MAPipt);
if err.flag
    return
end

%---------------------------------------------
% Create B0 Map
%---------------------------------------------
func = str2func([B0GEN.method,'_Func']);
INPUT.B0MAP = B0MAP;
[B0GEN,err] = func(INPUT,B0GEN);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B0GEN.ExpDisp = PanelStruct2Text(B0GEN.PanelOutput);
set(findobj('tag','TestBox'),'string',B0GEN.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Map:','Name Map',1,{'B0MAP_'});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
B0GEN.name = name;

%--------------------------------------------
% Rename
%--------------------------------------------
B0MAP = B0GEN;
B0MAP.type = 'B0Map';

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B0MAP};
SCRPTGBL.RWSUI.SaveVariableNames = {'B0MAP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
