%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = RoiCalcNpi_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Calculate Noise Precicison Interval (NPI) in ROI');
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
CALCTOP.method = SCRPTGBL.CurrentScript.Func;
CALCTOP.calcprecfunc = SCRPTGBL.CurrentTree.('CalcNpifunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALCipt = SCRPTGBL.CurrentTree.('CalcNpifunc');
if isfield(SCRPTGBL,('CalcNpifunc_Data'))
    CALCipt.CalcNpifunc_Data = SCRPTGBL.CalcNpifunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(CALCTOP.calcprecfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% Get ROI info
%---------------------------------------------
tab = SCRPTGBL.RWSUI.tab;
[ROIS,err] = Get_ROISofInterest(tab);
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([CALCTOP.method,'_Func']);
INPUT.CALC = CALC;
INPUT.ROIS = ROIS;
[CALCTOP,err] = func(CALCTOP,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
CALCTOP.ExpDisp = PanelStruct2Text(CALCTOP.CALC.PanelOutput);
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info.String = CALCTOP.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Analysis:');
if isempty(name)
    SCRPTGBL.RWSUI.KeepEdit = 'yes';
    return
end

%---------------------------------------------
% Naming
%---------------------------------------------
inds = strcmp('Analysis_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {CALCTOP};
SCRPTGBL.RWSUI.SaveVariableNames = {'CALCTOP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

