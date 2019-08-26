%=========================================================
% (v2a) 
%   - drop parameters from WRT structure to allow param write 
%       change without change to this file
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = TPI_VI47T_v2a(SCRPTipt,SCRPTGBL)

Status('busy','Write TPI Projection Set to 4.7T System');
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
WRT.wrtgradfunc = SCRPTGBL.CurrentTree.WrtGradfunc.Func;
WRT.wrtparamfunc = SCRPTGBL.CurrentTree.WrtParamfunc.Func;
WRT.wrtrefocusfunc = SCRPTGBL.CurrentTree.WrtRefocusfunc.Func;

%---------------------------------------------
% Load Implementation
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
WRTGRDipt = SCRPTGBL.CurrentTree.('WrtGradfunc');
if isfield(SCRPTGBL,('WrtGradfunc_Data'))
    WRTGRDipt.WrtGradfunc_Data = SCRPTGBL.WrtGradfunc_Data;
end
WRTPRMipt = SCRPTGBL.CurrentTree.('WrtParamfunc');
if isfield(SCRPTGBL,('WrtParamfunc_Data'))
    WRTPRMipt.WrtParamfunc_Data = SCRPTGBL.WrtParamfunc_Data;
end
WRTRFCSipt = SCRPTGBL.CurrentTree.('WrtRefocusfunc');
if isfield(SCRPTGBL,('WrtRefocusfunc_Data'))
    WRTRFCSipt.WrtRefocusfunc_Data = SCRPTGBL.WrtRefocusfunc_Data;
end

%------------------------------------------
% Get Write Gradient Function Info
%------------------------------------------
func = str2func(WRT.wrtgradfunc);           
[SCRPTipt,WRTGRD,err] = func(SCRPTipt,WRTGRDipt);
if err.flag
    return
end

%------------------------------------------
% Get Write Param Function Info
%------------------------------------------
func = str2func(WRT.wrtparamfunc);           
[SCRPTipt,WRTPRM,err] = func(SCRPTipt,WRTPRMipt);
if err.flag
    return
end

%------------------------------------------
% Get Write Refocus Function Info
%------------------------------------------
func = str2func(WRT.wrtrefocusfunc);           
[SCRPTipt,WRTRFCS,err] = func(SCRPTipt,WRTRFCSipt);
if err.flag
    return
end

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.script,'_Func']);
INPUT.WRTGRD = WRTGRD;
INPUT.WRTPRM = WRTPRM;
INPUT.WRTRFCS = WRTRFCS;
INPUT.IMP = IMP;
[WRT,err] = func(INPUT,WRT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
WRT.ExpDisp = PanelStruct2Text(WRT.PanelOutput);
set(findobj('tag','TestBox'),'string',WRT.ExpDisp);

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Writing:');
name = cell2mat(name);
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

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
