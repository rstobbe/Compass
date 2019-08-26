%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ExportImage_v1a(SCRPTipt,SCRPTGBL)

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
EXPORT.exportfunc = SCRPTGBL.CurrentTree.('ExportImagefunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LFipt = SCRPTGBL.CurrentTree.('LoadImagefunc');
if isfield(SCRPTGBL,('LoadImagefunc_Data'))
    LFipt.LoadImagefunc_Data = SCRPTGBL.LoadImagefunc_Data;
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
INPUT.EF = EF;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'mo';

