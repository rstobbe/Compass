%=========================================================
% (v1b) 
%       - Gridding k-Space as a sub-function 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Grid_noSDC_TrjSel_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Grid Data with no SDC');
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
GRD.traj = SCRPTGBL.CurrentTree.('Traj');
GRD.gridfunc = SCRPTGBL.CurrentTree.('Gridfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDUipt = SCRPTGBL.CurrentTree.('Gridfunc');
if isfield(SCRPTGBL,('Gridfunc_Data'))
    GRDUipt.Gridfunc_Data = SCRPTGBL.Gridfunc_Data;
end

%------------------------------------------
% Get Object Function Info
%------------------------------------------
func = str2func(GRD.gridfunc);           
[SCRPTipt,GRDU,err] = func(SCRPTipt,GRDUipt);
if err.flag
    return
end

%---------------------------------------------
% Load Kernel / Imp
%---------------------------------------------
IMP = SCRPTGBL.Imp_File_Data.IMP;

%---------------------------------------------
% Grid
%---------------------------------------------
func = str2func([GRD.script,'_Func']);
INPUT.GRD = GRD;
INPUT.IMP = IMP;
INPUT.GRDU = GRDU;
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
[SCRPTGBL] = AddToPanelOutput_B9(SCRPTGBL,'kSz',GRD.Ksz,'Output');

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
SCRPTGBL.RWSUI.SaveScriptName = 'Grid_noSDC';

Status('done','');
Status2('done','',2);
Status2('done','',3);
