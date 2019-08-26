%=========================================================
% (v1b) 
%       - Add Image Manipulation Funcion
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ExportImage_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Export_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';
setfunc = 1;
DispScriptParam(SCRPTipt,setfunc,SCRPTGBL.RWSUI.tab,SCRPTGBL.RWSUI.panelnum);

%---------------------------------------------
% Get Input
%---------------------------------------------
EXPORT.method = SCRPTGBL.CurrentScript.Func;
EXPORT.loadfunc = SCRPTGBL.CurrentTree.('LoadImagefunc').Func;
EXPORT.manipfunc = SCRPTGBL.CurrentTree.('ManipImagefunc').Func;
EXPORT.exportfunc = SCRPTGBL.CurrentTree.('ExportImagefunc').Func;
EXPORT.saveoption = SCRPTGBL.CurrentTree.('SaveOption');
EXPORT.loadoption = SCRPTGBL.CurrentTree.('LoadOutputGlobal');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LFipt = SCRPTGBL.CurrentTree.('LoadImagefunc');
if isfield(SCRPTGBL,('LoadImagefunc_Data'))
    LFipt.LoadImagefunc_Data = SCRPTGBL.LoadImagefunc_Data;
end
MANIPipt = SCRPTGBL.CurrentTree.('ManipImagefunc');
if isfield(SCRPTGBL,('ManipImagefunc_Data'))
    MANIPipt.ManipImagefunc_Data = SCRPTGBL.ManipImagefunc_Data;
end
EFipt = SCRPTGBL.CurrentTree.('ExportImagefunc');
if isfield(SCRPTGBL,('ExportImagefunc_Data'))
    EFipt.ExportImagefunc_Data = SCRPTGBL.ExportImagefunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(EXPORT.loadfunc);           
[SCRPTipt,SCRPTGBL,LF,err] = func(SCRPTipt,SCRPTGBL,LFipt);
if err.flag
    return
end
IMG = LF.IMG;
clear LF;
func = str2func(EXPORT.manipfunc);           
[SCRPTipt,MANIP,err] = func(SCRPTipt,MANIPipt);
if err.flag
    return
end
func = str2func(EXPORT.exportfunc);           
[SCRPTipt,EF,err] = func(SCRPTipt,EFipt);
if err.flag
    return
end

%---------------------------------------------
% Export
%---------------------------------------------
func = str2func([EXPORT.method,'_Func']);
INPUT.IMG = IMG;
INPUT.MANIP = MANIP;
INPUT.EF = EF;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Output to TextBox
%--------------------------------------------
%EXPORT.ExpDisp = PanelStruct2Text(EXPORT.PanelOutput);
%global FIGOBJS
%FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = EXPORT.ExpDisp;

%--------------------------------------------
% Return Check
%--------------------------------------------
if strcmp(EXPORT.saveoption,'No')
    return
end

%--------------------------------------------
% Determine if AutoSave
%--------------------------------------------
global TOTALGBL
val = length(TOTALGBL(1,:));
auto = 0;
if not(isempty(val)) && val ~= 0
    Gbl = TOTALGBL{2,val};
    if isfield(Gbl,'AutoRecon')
        if strcmp(Gbl.AutoSave,'yes')
            auto = 1;
            SCRPTGBL.RWSUI.SaveScript = 'yes';
            name = ['EXPORT_',Gbl.SaveName];
        end
    end
end

%--------------------------------------------
% Name
%--------------------------------------------  
if auto == 0
    if strfind(EXPORT.saveoption,'Auto')
        name = ['EXPORT_',EXPORT.name];
    else
        name = inputdlg('Name Export:','Name Export',1,{['EXPORT_',EXPORT.name]});
        name = cell2mat(name);
        if isempty(name)
            SCRPTGBL.RWSUI.KeepEdit = 'yes';
            return
        end
    end
end

%--------------------------------------------
% Update
%--------------------------------------------
EXPORT.name = name;

%--------------------------------------------
% Saving Options
%--------------------------------------------
if strcmp(EXPORT.saveoption,'AutoGlobalOnly') || strcmp(EXPORT.saveoption,'None')
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
elseif strcmp(EXPORT.saveoption,'AutoFileOnly')
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
else
    SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
end

if strcmp(EXPORT.saveoption,'AutoFileOnly') || strcmp(EXPORT.saveoption,'None')
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
elseif strcmp(EXPORT.saveoption,'AutoGlobalOnly')
    SCRPTGBL.RWSUI.SaveGlobal = 'auto';
else
    SCRPTGBL.RWSUI.SaveGlobal = 'yes';
end

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTipt(indnum).entrystr = EXPORT.name;
SCRPTGBL.RWSUI.SaveVariables = EXPORT;
SCRPTGBL.RWSUI.SaveVariableNames = 'EXPORT';
SCRPTGBL.RWSUI.SaveGlobalNames = EXPORT.name;
SCRPTGBL.RWSUI.SaveScriptPath = EXPORT.path;
SCRPTGBL.RWSUI.SaveScriptName = EXPORT.name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

