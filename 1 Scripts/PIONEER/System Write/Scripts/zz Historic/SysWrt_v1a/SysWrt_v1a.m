%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SysWrt_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Write Gradients Etc For Different Systems');
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

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.script = SCRPTGBL.CurrentTree.Func;
WRT.wrtsysfunc = SCRPTGBL.CurrentTree.WrtSysfunc.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTSYSipt = SCRPTGBL.CurrentTree.('WrtSysfunc');
if isfield(SCRPTGBL,('WrtSysfunc_Data'))
    WRTSYSipt.WrtSysfunc_Data = SCRPTGBL.WrtSysfunc_Data;
end

%------------------------------------------
% Get Write Gradient Function Info
%------------------------------------------
func = str2func(WRT.wrtsysfunc);           
[SCRPTipt,WRTSYS,err] = func(SCRPTipt,WRTSYSipt);
if err.flag
    return
end

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.script,'_Func']);
INPUT.WRTSYS = WRTSYS;
INPUT.IMP = IMP;
[WRT,err] = func(INPUT,WRT);
if err.flag
    return
end

%--------------------------------------------
% Name
%--------------------------------------------
name = ['WRT_',IMP.name(5:end)];

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Writing:','System Writing',1,{name});
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
SCRPTGBL.RWSUI.SaveVariableNames = {'WRT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);
