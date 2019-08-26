%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ConvertDiffImage_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Convert Diffusion Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
CVT.script = SCRPTGBL.CurrentTree.Func;
CVT.loadmeth = SCRPTGBL.CurrentTree.LoadDWIfunc.Func;
CVT.exportmeth = SCRPTGBL.CurrentTree.ExportDWIfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('LoadDWIfunc');
if isfield(SCRPTGBL,('LoadDWIfunc_Data'))
    LOADipt.LoadDWIfunc_Data = SCRPTGBL.LoadDWIfunc_Data;
end

EXPORTipt = SCRPTGBL.CurrentTree.('ExportDWIfunc');
if isfield(SCRPTGBL,('ExportDWIfunc_Data'))
    EXPORTipt.ExportDWIfunc_Data = SCRPTGBL.ExportDWIfunc_Data;
end

%------------------------------------------
% Get Load Function Info
%------------------------------------------
func = str2func(CVT.loadmeth);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
end

%------------------------------------------
% Get Export Function Info
%------------------------------------------
func = str2func(CVT.exportmeth);           
[SCRPTipt,EXPORT,err] = func(SCRPTipt,EXPORTipt);
if err.flag
    return
end

%---------------------------------------------
% Convert Image
%---------------------------------------------
func = str2func([CVT.script,'_Func']);
INPUT.LOAD = LOAD;
INPUT.EXPORT = EXPORT;
[OUTPUT,err] = func(INPUT,CVT);
if err.flag
    return
end
clear INPUT

%--------------------------------------------
% Return
%--------------------------------------------
if OUTPUT.saveflag == 1
    name = inputdlg('Name Image:');
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
else
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
    return
end

IMG = OUTPUT.IMG;
%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = {'IMG'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);




