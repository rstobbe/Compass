%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ROI_Edit_v1b(SCRPTipt,SCRPTGBL)

Status('busy','ROI Edit');
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
[SCRPTipt,SCRPTGBL,EDIT,err] = func(SCRPTipt,SCRPTGBL,EDITipt);
if err.flag
    return
end
func = str2func(ROIEDIT.outfunc);           
[SCRPTipt,OUT,err] = func(SCRPTipt,OUTipt);
if err.flag
    return
end

%---------------------------------------------
% Edit
%---------------------------------------------
func = str2func([ROIEDIT.method,'_Func']);
INPUT.EDIT = EDIT;
INPUT.LOAD = LOAD;
INPUT.OUT = OUT;
[ROIEDIT,err] = func(ROIEDIT,INPUT);
if err.flag
    return
end

ROIARR = ROIEDIT.ROIARR;
ROIEDIT = rmfield(ROIEDIT,'ROIARR');

%---------------------------------------------
% Rois Save
%--------------------------------------------- 
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';
SCRPTGBL.RWSUI.SaveVariables = ROIEDIT;
SCRPTGBL.RWSUI.SaveVariableNames = 'ROIEDIT';
SCRPTGBL.RWSUI.SaveGlobalNames = 'ROIEDIT';
SCRPTGBL.RWSUI.SaveRois = ROIEDIT.SaveRois;
SCRPTGBL.RWSUI.LoadRois = ROIEDIT.LoadRois;
SCRPTGBL.RWSUI.ROIARR = ROIARR;

Status('done','');
Status2('done','',2);
Status2('done','',3);
