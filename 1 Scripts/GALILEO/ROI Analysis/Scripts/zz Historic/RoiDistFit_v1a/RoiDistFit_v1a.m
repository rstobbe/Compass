%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = RoiDistFit_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Fit ROI Distributions');
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
FITTOP.method = SCRPTGBL.CurrentScript.Func;
FITTOP.fitdistfunc = SCRPTGBL.CurrentTree.('FitDistfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = SCRPTGBL.CurrentTree.('FitDistfunc');
if isfield(SCRPTGBL,('FitDistfunc_Data'))
    FITipt.FitDistfunc_Data = SCRPTGBL.FitDistfunc_Data;
end

%------------------------------------------
% Get Calc Function Info
%------------------------------------------
func = str2func(FITTOP.fitdistfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end

%---------------------------------------------
% Get ROI info
%---------------------------------------------
tab = SCRPTGBL.RWSUI.tab;
[ROIS,axnum,err] = Get_ROISofInterest(tab);
if err.flag
    return
end

%---------------------------------------------
% Calc
%---------------------------------------------
func = str2func([FITTOP.method,'_Func']);
INPUT.FIT = FIT;
INPUT.ROIS = ROIS;
[FITTOP,err] = func(FITTOP,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
global FIGOBJS
FIGOBJS.(SCRPTGBL.RWSUI.tab).Info(axnum).String = FITTOP.ExpDisp;

%--------------------------------------------
% Return
%--------------------------------------------
if strcmp(FITTOP.saveable,'yes')
    name = inputdlg('Name Analysis:');
    if isempty(name)
        SCRPTGBL.RWSUI.KeepEdit = 'yes';
        return
    end
else
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

SCRPTGBL.RWSUI.SaveVariables = {FITTOP};
SCRPTGBL.RWSUI.SaveVariableNames = {'FITTOP'};
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = cell2mat(name);

Status('done','');
Status2('done','',2);
Status2('done','',3);

