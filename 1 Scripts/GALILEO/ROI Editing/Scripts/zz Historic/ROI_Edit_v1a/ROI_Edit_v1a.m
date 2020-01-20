%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROI_Edit_v1a(SCRPTipt,SCRPTGBL)

Status('busy','ROI Edit');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('RoiEdit_Name',{SCRPTipt.labelstr});
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
ROIEDIT.method = SCRPTGBL.CurrentScript.Func;
ROIEDIT.loadfunc = SCRPTGBL.CurrentTree.('RoiLoadfunc').Func;
ROIEDIT.editfunc = SCRPTGBL.CurrentTree.('RoiEditfunc').Func;
ROIEDIT.outfunc = SCRPTGBL.CurrentTree.('RoiOutputfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('RoiLoadfunc');
if isfield(SCRPTGBL,('RoiLoadfunc_Data'))
    LOADipt.RoiLoadfunc_Data = SCRPTGBL.RoiLoadfunc_Data;
end
EDITipt = SCRPTGBL.CurrentTree.('RoiEditfunc');
if isfield(SCRPTGBL,('RoiEditfunc_Data'))
    EDITipt.RoiEditfunc_Data = SCRPTGBL.RoiEditfunc_Data;
end
OUTipt = SCRPTGBL.CurrentTree.('RoiOutputfunc');
if isfield(SCRPTGBL,('RoiOutputfunc_Data'))
    OUTipt.RoiOutputfunc_Data = SCRPTGBL.RoiOutputfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(ROIEDIT.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
func = str2func(ROIEDIT.editfunc);           
[SCRPTipt,EDIT,err] = func(SCRPTipt,EDITipt);
if err.flag
    return
end
func = str2func(ROIEDIT.outfunc);           
[SCRPTipt,OUT,err] = func(SCRPTipt,OUTipt);
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([ROIEDIT.method,'_Func']);
INPUT.EDIT = EDIT;
INPUT.LOAD = LOAD;
INPUT.OUT = OUT;
[ROIEDIT,err] = func(ROIEDIT,INPUT);
if err.flag
    return
end

SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

return

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info(axnum).String = ROIEDIT.ExpDisp;
if isfield(FIGOBJS.(tab),'InfoTab')
    FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTab(axnum);
elseif isfield(FIGOBJS.(tab),'InfoTabL')
    FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTabL;
end
FIGOBJS.(SCRPTGBL.RWSUI.tab).UberTabGroup.SelectedTab = FIGOBJS.(tab).TopInfoTab;

if strcmp(ROIEDIT.saveable,'no') || strcmp(ROIEDIT.saveable,'No')
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
    return
end

%--------------------------------------------
% Name
%--------------------------------------------
auto = 0;
if auto == 0
    name = inputdlg('Name Edit:','Name Edit',1,{'ANLZ_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {ROIEDIT};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
ROIEDIT.name = name;
ROIEDIT.path = IMAGEANLZ.IMPATH;
ROIEDIT.type = 'Edit';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = ROIEDIT;
SCRPTGBL.RWSUI.SaveVariableNames = 'ROIEDIT';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = ROIEDIT.path;
SCRPTGBL.RWSUI.SaveScriptName = name;
SCRPTGBL.RWSUI.axnum = axnum;

Status('done','');
Status2('done','',2);
Status2('done','',3);
