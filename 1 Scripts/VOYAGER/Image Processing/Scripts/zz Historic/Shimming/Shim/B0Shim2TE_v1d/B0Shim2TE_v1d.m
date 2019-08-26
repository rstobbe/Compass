%===========================================
% (v1d)
% - ShimCal frequency 'type' select 
%===========================================

function [SCRPTipt,SCRPTGBL,err] = B0Shim2TE_v1d(SCRPTipt,SCRPTGBL)

Status('busy','Shim B0');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Shim_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Test / Load Calibration File
%---------------------------------------------
if not(isfield(SCRPTGBL,'Cal_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Cal_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Cal_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Cal_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Calibration File');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Cal_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Cal_File';
        ErrDisp(err);
        return
    end
end  
CAL = SCRPTGBL.Cal_File_Data.CAL;

%---------------------------------------------
% Load Input
%---------------------------------------------
SHIM.method = SCRPTGBL.CurrentTree.Func;
SHIM.resizefunc = SCRPTGBL.CurrentTree.('ReSizefunc').Func;
SHIM.baseimfunc = SCRPTGBL.CurrentTree.('BaseImfunc').Func;
SHIM.loadfunc = SCRPTGBL.CurrentTree.('ImLoadfunc').Func;
SHIM.mapfunc = SCRPTGBL.CurrentTree.('B0Mapfunc').Func;
SHIM.maskfunc = SCRPTGBL.CurrentTree.('Maskfunc').Func;
SHIM.fitfunc = SCRPTGBL.CurrentTree.('Shimfunc').Func;
SHIM.dispfunc = SCRPTGBL.CurrentTree.('Dispfunc').Func;
SHIM.shimcalpol = SCRPTGBL.CurrentTree.('ShimCalPol');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('ImLoadfunc');
if isfield(SCRPTGBL,('ImLoadfunc_Data'))
    LOADipt.ImLoadfunc_Data = SCRPTGBL.ImLoadfunc_Data;
end
RESZipt = SCRPTGBL.CurrentTree.('ReSizefunc');
if isfield(SCRPTGBL,('ReSizefunc_Data'))
    RESZipt.ReSizefunc_Data = SCRPTGBL.ReSizefunc_Data;
end
BASEipt = SCRPTGBL.CurrentTree.('BaseImfunc');
if isfield(SCRPTGBL,('BaseImfunc_Data'))
    BASEipt.BaseImfunc_Data = SCRPTGBL.BaseImfunc_Data;
end
MAPipt = SCRPTGBL.CurrentTree.('B0Mapfunc');
if isfield(SCRPTGBL,('B0Mapfunc_Data'))
    MAPipt.B0Mapfunc_Data = SCRPTGBL.B0Mapfunc_Data;
end
MASKipt = SCRPTGBL.CurrentTree.('Maskfunc');
if isfield(SCRPTGBL,('Maskfunc_Data'))
    MASKipt.Maskfunc_Data = SCRPTGBL.Maskfunc_Data;
end
FITipt = SCRPTGBL.CurrentTree.('Shimfunc');
if isfield(SCRPTGBL,('Shimfunc_Data'))
    FITipt.Shimfunc_Data = SCRPTGBL.Shimfunc_Data;
end
DISPipt = SCRPTGBL.CurrentTree.('Dispfunc');
if isfield(SCRPTGBL,('Dispfunc_Data'))
    DISPipt.Dispfunc_Data = SCRPTGBL.Dispfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(SHIM.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
IMG = LOAD.IMG;
clear LOAD;
func = str2func(SHIM.resizefunc);           
[SCRPTipt,RESZ,err] = func(SCRPTipt,RESZipt);
if err.flag
    return
end
func = str2func(SHIM.baseimfunc);           
[SCRPTipt,BASE,err] = func(SCRPTipt,BASEipt);
if err.flag
    return
end
func = str2func(SHIM.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end
func = str2func(SHIM.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end
func = str2func(SHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end
func = str2func(SHIM.dispfunc);
[SCRPTipt,SCRPTGBL,DISP,err] = func(SCRPTipt,SCRPTGBL,DISPipt);
if err.flag
    return
end

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.method,'_Func']);
INPUT.IMG = IMG;
INPUT.RESZ = RESZ;
INPUT.BASE = BASE;
INPUT.CAL = CAL;
INPUT.MAP = MAP;
INPUT.MASK = MASK;
INPUT.FIT = FIT;
INPUT.DISP = DISP;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[SHIM,err] = func(SHIM,INPUT);
if err.flag
    return
end
SCRPTipt = SHIM.SCRPTipt;

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
SHIM.ExpDisp = PanelStruct2Text(SHIM.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = SHIM.ExpDisp;

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
            name = ['SHIM_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------
if auto == 0;
    name = inputdlg('Name Map:','Name Map',1,{'SHIM_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
SHIM.name = name;
SHIM.path = IMG{1}.path;

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = SHIM.name;
SCRPTGBL.RWSUI.SaveVariables = SHIM;
SCRPTGBL.RWSUI.SaveVariableNames = 'SHIM';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = SHIM.name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = SHIM.path;
SCRPTGBL.RWSUI.SaveScriptName = SHIM.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
