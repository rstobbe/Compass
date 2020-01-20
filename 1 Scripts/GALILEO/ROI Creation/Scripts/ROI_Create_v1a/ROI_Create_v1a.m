%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROI_Create_v1a(SCRPTipt,SCRPTGBL)

Status('busy','ROI Create');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Roi_Name',{SCRPTipt.labelstr});
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
ROICREATE.method = SCRPTGBL.CurrentScript.Func;
ROICREATE.createfunc = SCRPTGBL.CurrentTree.('RoiCreatefunc').Func;
ROICREATE.outfunc = SCRPTGBL.CurrentTree.('RoiOutputfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CREATEipt = SCRPTGBL.CurrentTree.('RoiCreatefunc');
if isfield(SCRPTGBL,('RoiCreatefunc_Data'))
    CREATEipt.RoiCreatefunc_Data = SCRPTGBL.RoiCreatefunc_Data;
end
OUTipt = SCRPTGBL.CurrentTree.('RoiOutputfunc');
if isfield(SCRPTGBL,('RoiOutputfunc_Data'))
    OUTipt.RoiOutputfunc_Data = SCRPTGBL.RoiOutputfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(ROICREATE.createfunc);           
[SCRPTipt,SCRPTGBL,CREATE,err] = func(SCRPTipt,SCRPTGBL,CREATEipt);
if err.flag
    return
end
func = str2func(ROICREATE.outfunc);           
[SCRPTipt,OUT,err] = func(SCRPTipt,OUTipt);
if err.flag
    return
end

%---------------------------------------------
% Create
%---------------------------------------------
func = str2func([ROICREATE.method,'_Func']);
INPUT.CREATE = CREATE;
INPUT.OUT = OUT;
[ROICREATE,err] = func(ROICREATE,INPUT);
if err.flag
    return
end

ROIARR = ROICREATE.ROIARR;
ROICREATE = rmfield(ROICREATE,'ROIARR');

%---------------------------------------------
% Rois Save
%--------------------------------------------- 
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
SCRPTGBL.RWSUI.SaveVariables = ROICREATE;
SCRPTGBL.RWSUI.SaveVariableNames = 'ROICREATE';
SCRPTGBL.RWSUI.SaveGlobalNames = 'ROICREATE';
SCRPTGBL.RWSUI.SaveRois = ROICREATE.SaveRois;
SCRPTGBL.RWSUI.LoadRois = ROICREATE.LoadRois;
SCRPTGBL.RWSUI.ROIARR = ROIARR;

Status('done','');
Status2('done','',2);
Status2('done','',3);
