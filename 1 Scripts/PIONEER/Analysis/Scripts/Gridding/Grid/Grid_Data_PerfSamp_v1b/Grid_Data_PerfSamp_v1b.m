%=========================================================
% (v1b) 
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_Data_PerfSamp_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Grid Data with SDC');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Imp_File';
    ErrDisp(err);
    return
elseif not(isfield(SCRPTGBL,'SDC_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load SDC_File';
    ErrDisp(err);
    return
elseif not(isfield(SCRPTGBL,'kSamp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Samp_File';
    return
end

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Grid_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
GRD.script = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Data
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;
SDCS = SCRPTGBL.SDC_File_Data.SDCS;
KSMP = SCRPTGBL.kSamp_File_Data.SAMP;

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([GRD.script,'_Func']);
INPUT.GRD = GRD;
INPUT.IMP = IMP;
INPUT.SDCS = SDCS;
INPUT.KSMP = KSMP;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output
%--------------------------------------------
GRD = OUTPUT.GRD;

%--------------------------------------------
% Display
%--------------------------------------------
%[SCRPTGBL] = AddToPanelOutput_B9(SCRPTGBL,'kSz',GRD.Ksz,'Output');

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Gridding:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Grid_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {GRD};
SCRPTGBL.RWSUI.SaveVariableNames = {'GRD'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'GridPrf';

Status('done','');
Status2('done','',2);
Status2('done','',3);
