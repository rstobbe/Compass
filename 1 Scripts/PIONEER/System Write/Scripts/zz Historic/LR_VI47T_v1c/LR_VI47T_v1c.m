%=========================================================
% (v1c) 
%   - start with TPI_VI47T_v1c
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LR_VI47T_v1c(SCRPTipt,SCRPTGBL)

Status('busy','Write LR Projection Set to 4.7T System');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Implementation File';
    return
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('SysWrt_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
WRT.script = SCRPTGBL.CurrentTree.Func;
WRT.defgcoil = SCRPTGBL.CurrentTree.('def_gcoil');
WRT.defgraddel = str2double(SCRPTGBL.CurrentTree.('def_graddel'));
WRT.wrtgradfunc = SCRPTGBL.CurrentTree.WrtGradfunc.Func;
WRT.wrtparamfunc = SCRPTGBL.CurrentTree.WrtParamfunc.Func;

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

%---------------------------------------------
% Write
%---------------------------------------------
func = str2func([WRT.script,'_Func']);
INPUT.WRT = WRT;
INPUT.WRTGRD = WRTGRD;
INPUT.WRTPRM = WRTPRM;
INPUT.IMP = IMP;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output
%--------------------------------------------
WRT = OUTPUT.WRT;

%--------------------------------------------
% Display
%--------------------------------------------
SCRPTGBL.RWSUI.LocalOutput = WRT.PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name System Writing:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('SysWrt_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {WRT};
SCRPTGBL.RWSUI.SaveVariableNames = {'WRT'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'WRT';

Status('done','');
Status2('done','',2);
Status2('done','',3);

