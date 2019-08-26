%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Compare2Griddings_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Compare Griddings');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Comparison_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Imp_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Imp_File';
    return
end
if not(isfield(SCRPTGBL,'Grid_File1_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Grid_File1';
    return
end
if not(isfield(SCRPTGBL,'Grid_File2_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Grid_File2';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
COMP.method = SCRPTGBL.CurrentTree.Func;
IMP = SCRPTGBL.('Imp_File_Data').IMP;
grd1 = SCRPTGBL.('Grid_File1_Data').GRD;
grd2 = SCRPTGBL.('Grid_File2_Data').GRD;

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([COMP.method,'_Func']);
INPUT.COMP = COMP;
INPUT.IMP = IMP;
INPUT.grd1 = grd1;
INPUT.grd2 = grd2;
[COMP,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Comparison:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Comparison_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {COMP};
SCRPTGBL.RWSUI.SaveVariableNames = {'COMP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'Comp';

Status('done','');
Status2('done','',2);
Status2('done','',3);
