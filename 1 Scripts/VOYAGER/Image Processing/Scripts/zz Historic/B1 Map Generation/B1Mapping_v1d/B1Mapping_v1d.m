%===========================================
% (v1d)
%       - 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B1Mapping_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Map B1');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
B1MAP.method = SCRPTGBL.CurrentTree.Func;
B1MAP.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
B1MAP.baseimfunc = SCRPTGBL.CurrentTree.('BaseImfunc').Func;
B1MAP.mapfunc = SCRPTGBL.CurrentTree.('B1Mapfunc').Func;
B1MAP.return = SCRPTGBL.CurrentTree.('Return');
B1MAP.plot = SCRPTGBL.CurrentTree.('Plot');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
BASEipt = SCRPTGBL.CurrentTree.('BaseImfunc');
if isfield(SCRPTGBL,('BaseImfunc_Data'))
    BASEipt.BaseImfunc_Data = SCRPTGBL.BaseImfunc_Data;
end
MAPipt = SCRPTGBL.CurrentTree.('B1Mapfunc');
if isfield(SCRPTGBL,('B1Mapfunc_Data'))
    MAPipt.B1Mapfunc_Data = SCRPTGBL.B1Mapfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
func = str2func(B1MAP.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(B1MAP.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
if err.flag
    return
end
func = str2func(B1MAP.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.method,'_Func']);
INPUT.IMG = IMG;
INPUT.BASE = BASE;
INPUT.MAP = MAP;
[B1MAP,err] = func(B1MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B1MAP.ExpDisp = PanelStruct2Text(B1MAP.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = B1MAP.ExpDisp;

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
auto = 0;
RWSUI = SCRPTGBL.RWSUI;
if isfield(RWSUI,'ExtRunInfo')
    auto = 1;
    if strcmp(RWSUI.ExtRunInfo.save,'no');
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'no';
    elseif strcmp(RWSUI.ExtRunInfo.save,'all');
        SCRPTGBL.RWSUI.SaveScript = 'yes';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    elseif strcmp(RWSUI.ExtRunInfo.save,'global');
        SCRPTGBL.RWSUI.SaveScript = 'no';
        SCRPTGBL.RWSUI.SaveGlobal = 'yes';
    end
    name = ['B1MAP_',B1MAP.name];
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'B1MAP_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
B1MAP.name = name;
if iscell(IMG)
    B1MAP.path = IMG{1}.path;
else
    B1MAP.path = IMG.path;
end
B1MAP.type = 'Image'; 

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B1MAP};
SCRPTGBL.RWSUI.SaveVariableNames = {'B1MAP'};
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptPath = B1MAP.path;
SCRPTGBL.RWSUI.SaveScriptName = [name,'.mat'];

Status('done','');
Status2('done','',2);
Status2('done','',3);