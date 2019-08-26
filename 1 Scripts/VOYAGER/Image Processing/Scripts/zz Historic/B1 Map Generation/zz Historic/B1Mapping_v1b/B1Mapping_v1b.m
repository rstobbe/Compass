%===========================================
% (v1b)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B1Mapping_v1b(SCRPTipt,SCRPTGBL)

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
DispScriptParam_B9(SCRPTipt,setfunc,SCRPTGBL.RWSUI.panel);

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
B1MAP.method = SCRPTGBL.CurrentTree.Func;
B1MAP.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
B1MAP.mapfunc = SCRPTGBL.CurrentTree.('B1Mapfunc').Func;
B1MAP.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
MAPipt = SCRPTGBL.CurrentTree.('B1Mapfunc');
if isfield(SCRPTGBL,('B1Mapfunc_Data'))
    MAPipt.B1Mapfunc_Data = SCRPTGBL.B1Mapfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
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
func = str2func(B1MAP.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end
func = str2func(B1MAP.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([B1MAP.method,'_Func']);
INPUT.IMG = IMG;
INPUT.MAP = MAP;
INPUT.DISP = DISP;
[B1MAP,err] = func(B1MAP,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
B1MAP.ExpDisp = PanelStruct2Text(B1MAP.PanelOutput);
set(findobj('tag','TestBox'),'string',B1MAP.ExpDisp);

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        if strcmp(Gbl.AutoSave,'yes')
            auto = 1;
            SCRPTGBL.RWSUI.SaveScript = 'yes';
            name = ['B1MAP_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'B1MAP'});
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

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {B1MAP};
SCRPTGBL.RWSUI.SaveVariableNames = {'B1MAP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = B1MAP.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);