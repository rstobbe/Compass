%=========================================================
% (v1b) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROI_Characteristics_v1b(SCRPTipt,SCRPTGBL)

Status('busy','ROI Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
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
ROIANLZ.method = SCRPTGBL.CurrentScript.Func;
ROIANLZ.loadfunc = SCRPTGBL.CurrentTree.('RoiLoadfunc').Func;
ROIANLZ.analysisfunc = SCRPTGBL.CurrentTree.('Analysisfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('RoiLoadfunc');
if isfield(SCRPTGBL,('RoiLoadfunc_Data'))
    LOADipt.RoiLoadfunc_Data = SCRPTGBL.RoiLoadfunc_Data;
end
CALCipt = SCRPTGBL.CurrentTree.('Analysisfunc');
if isfield(SCRPTGBL,('Analysisfunc_Data'))
    CALCipt.Analysisfunc_Data = SCRPTGBL.Analysisfunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(ROIANLZ.loadfunc);           
[SCRPTipt,SCRPTGBL,LOAD,err] = func(SCRPTipt,SCRPTGBL,LOADipt);
if err.flag
    return
end
func = str2func(ROIANLZ.analysisfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([ROIANLZ.method,'_Func']);
INPUT.LOAD = LOAD;
INPUT.CALC = CALC;
[ROIANLZ,err] = func(ROIANLZ,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
global FIGOBJS
% axnum = LOAD.axnum;
axnum = 1;
tab = SCRPTGBL.RWSUI.tab;
if isfield(FIGOBJS.(tab),'InfoTab')
    FIGOBJS.(tab).Info(axnum).String = ROIANLZ.ExpDisp;
    FIGOBJS.(tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTab(axnum);
elseif isfield(FIGOBJS.(tab),'InfoTabL')
    FIGOBJS.(tab).InfoL.String = ROIANLZ.ExpDisp;
    FIGOBJS.(tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTabL;
end
FIGOBJS.(tab).UberTabGroup.SelectedTab = FIGOBJS.(tab).TopInfoTab;

if strcmp(ROIANLZ.saveable,'no') || strcmp(ROIANLZ.saveable,'No')
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
    return
end

%--------------------------------------------
% Name
%--------------------------------------------
auto = 0;
if auto == 0
    name = inputdlg('Name Analysis:','Name Analysis',1,{['ANLZ_',ROIANLZ.name]});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {ROIANLZ};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
ROIANLZ.name = name;
ROIANLZ.path = LOAD.Path{1};
ROIANLZ.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = ROIANLZ;
SCRPTGBL.RWSUI.SaveVariableNames = 'ROIANLZ';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = ROIANLZ.path;
SCRPTGBL.RWSUI.SaveScriptName = name;
SCRPTGBL.RWSUI.axnum = axnum;

Status('done','');
Status2('done','',2);
Status2('done','',3);
