%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROI_ParameterCalc_v1a(SCRPTipt,SCRPTGBL)

global IMAGEANLZ

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
ROIANLZ.analysisfunc = SCRPTGBL.CurrentTree.('Analysisfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALCipt = SCRPTGBL.CurrentTree.('Analysisfunc');
if isfield(SCRPTGBL,('Analysisfunc_Data'))
    CALCipt.Analysisfunc_Data = SCRPTGBL.Analysisfunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(ROIANLZ.analysisfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Get ROI info
%---------------------------------------------
tab = SCRPTGBL.RWSUI.tab;
[ROIS,axnum,err] = GetROISofInterest(tab);
SCRPTGBL.RWSUI.axnum = axnum;
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([ROIANLZ.method,'_Func']);
INPUT.CALC = CALC;
INPUT.ROIS = ROIS;
INPUT.IMAGEANLZ = IMAGEANLZ.(tab)(axnum);
INPUT.tab = tab;
[ROIANLZ,err] = func(ROIANLZ,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info(axnum).String = ROIANLZ.ExpDisp;
FIGOBJS.(SCRPTGBL.RWSUI.tab).InfoTabGroup.SelectedTab = FIGOBJS.(tab).InfoTab(axnum);
FIGOBJS.(SCRPTGBL.RWSUI.tab).UberTabGroup.SelectedTab = FIGOBJS.(tab).TopInfoTab;

if strcmp(ROIANLZ.saveable,'no')
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    SCRPTGBL.RWSUI.SaveScriptOption = 'no';
    return
end

%--------------------------------------------
% Name
%--------------------------------------------
auto = 0;
if auto == 0;
    name = inputdlg('Name Analysis:','Name Analysis',1,{'ANLZ_'});
    name = cell2mat(name);
    if isempty(name)
        SCRPTGBL.RWSUI.SaveVariables = {ROIANLZ};
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
end
ROIANLZ.name = name;
ROIANLZ.path = IMG.path;
ROIANLZ.type = 'Analysis';   

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTipt(indnum).entrystr = name;
SCRPTGBL.RWSUI.SaveVariables = {ROIANLZ};
SCRPTGBL.RWSUI.SaveVariableNames = {'ROIANLZ'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = IMG.path;
SCRPTGBL.RWSUI.SaveScriptName = name;
SCRPTGBL.RWSUI.axnum = axnum;

Status('done','');
Status2('done','',2);
Status2('done','',3);
