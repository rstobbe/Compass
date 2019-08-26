%=========================================================
% (v1c) 
%       - Facilitate k-space array
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SysReconWrt_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Write ');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('SysWrt_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Imp_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File - path no longer valid';
            ErrDisp(err);
            return
        else
            Status('busy','Load Trajectory Implementation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if not(isfield(SCRPTGBL,'SDC_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('SDC_File').Struct,'selectedfile')
    file = SCRPTGBL.CurrentTree.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            SCRPTGBL.('SDC_File_Data').SDCS = [];
        else
            Status('busy','Load Sampling Density Compensation');
            load(file);
            saveData.path = file;
            SCRPTGBL.('SDC_File_Data') = saveData;
        end
    else
        SCRPTGBL.('SDC_File_Data').SDCS = [];
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.method = SCRPTGBL.CurrentTree.Func;
WRT.wrtsysfunc = SCRPTGBL.CurrentTree.WrtSysfunc.Func;
WRT.trajorderfunc = SCRPTGBL.CurrentTree.TrajOrderfunc.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;
SDCS = SCRPTGBL.SDC_File_Data.SDCS;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTSYSipt = SCRPTGBL.CurrentTree.('WrtSysfunc');
if isfield(SCRPTGBL,('WrtSysfunc_Data'))
    WRTSYSipt.WrtSysfunc_Data = SCRPTGBL.WrtSysfunc_Data;
end
TORDipt = SCRPTGBL.CurrentTree.('TrajOrderfunc');
if isfield(SCRPTGBL,('TrajOrderfunc_Data'))
    TORDipt.TrajOrderfunc_Data = SCRPTGBL.TrajOrderfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(WRT.wrtsysfunc);           
[SCRPTipt,WRTSYS,err] = func(SCRPTipt,WRTSYSipt);
if err.flag
    return
end
func = str2func(WRT.trajorderfunc);           
[SCRPTipt,TORD,err] = func(SCRPTipt,TORDipt);
if err.flag
    return
end

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.method,'_Func']);
INPUT.WRTSYS = WRTSYS;
INPUT.TORD = TORD;
INPUT.IMP = IMP;
INPUT.SDCS = SDCS;
[WRT,err] = func(INPUT,WRT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
WRT.ExpDisp = PanelStruct2Text(WRT.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = WRT.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Writing:','System Writing',1,{WRT.name});
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end
WRT.name = name;

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {WRT};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMP'};             % for subsequent uses
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
