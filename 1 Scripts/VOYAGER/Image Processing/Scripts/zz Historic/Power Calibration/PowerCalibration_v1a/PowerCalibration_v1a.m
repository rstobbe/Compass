%===========================================
% (v1a)
%       - start B1Mapping_v1c
%===========================================

function [SCRPTipt,SCRPTGBL,err] = PowerCalibration_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Power Calibration');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Cal_Name',{SCRPTipt.labelstr});
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
PCAL.method = SCRPTGBL.CurrentTree.Func;
PCAL.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
PCAL.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;
PCAL.datcolfunc = SCRPTGBL.CurrentTree.('DatColfunc').Func;
PCAL.syswrtfunc = SCRPTGBL.CurrentTree.('SysWrtfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end
DATCOLipt = SCRPTGBL.CurrentTree.('DatColfunc');
if isfield(SCRPTGBL,('DatColfunc_Data'))
    DATCOLipt.DatColfunc_Data = SCRPTGBL.DatColfunc_Data;
end
SYSWRTipt = SCRPTGBL.CurrentTree.('SysWrtfunc');
if isfield(SCRPTGBL,('SysWrtfunc_Data'))
    SYSWRTipt.SysWrtfunc_Data = SCRPTGBL.SysWrtfunc_Data;
end

%------------------------------------------
% Get  Function Info
%------------------------------------------
RWSUI = SCRPTGBL.RWSUI;
func = str2func(PCAL.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(PCAL.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end
func = str2func(PCAL.datcolfunc);           
[SCRPTipt,DATCOL,err] = func(SCRPTipt,DATCOLipt);
if err.flag
    return
end
func = str2func(PCAL.syswrtfunc);           
[SCRPTipt,SCRPTGBL,SYSWRT,err] = func(SCRPTipt,SCRPTGBL,SYSWRTipt,RWSUI);
if err.flag
    return
end

%---------------------------------------------
% B1 Map
%---------------------------------------------
func = str2func([PCAL.method,'_Func']);
INPUT.IMG = IMG;
INPUT.DISP = DISP;
INPUT.DATCOL = DATCOL;
INPUT.SYSWRT = SYSWRT;
[PCAL,err] = func(PCAL,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
PCAL.ExpDisp = PanelStruct2Text(PCAL.PanelOutput);
set(findobj('tag','TestBox'),'string',PCAL.ExpDisp);

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
            name = 'PWRCAL';
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'PWRCAL'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
PCAL.name = name;
if iscell(IMG)
    PCAL.path = IMG{1}.path;
else
    PCAL.path = IMG.path;
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {PCAL};
SCRPTGBL.RWSUI.SaveVariableNames = {'PCAL'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = PCAL.path;
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);