%=========================================================
% (v1b)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = PerfSampMatchDes_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create Perfect Sampling Array');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('IMP_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Des_File_Data'))
    err.flag = 1;
    err.msg = '(Re)Load Des_File';
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
IMP.method = SCRPTGBL.CurrentTree.Func;
DES = SCRPTGBL.('Des_File_Data').DES;

%---------------------------------------------
% Create Image
%---------------------------------------------
func = str2func([IMP.method,'_Func']);
INPUT.IMP = IMP;
INPUT.DES = DES;
[IMP,err] = func(INPUT);
if err.flag
    return
end
IMP.ExpDisp = '';

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Perfect Sampling:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('IMP_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = name{1};

SCRPTGBL.RWSUI.SaveVariables = IMP;
SCRPTGBL.RWSUI.SaveVariableNames = 'IMP';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name{1};
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name{1};

Status('done','');
Status2('done','',2);
Status2('done','',3);
