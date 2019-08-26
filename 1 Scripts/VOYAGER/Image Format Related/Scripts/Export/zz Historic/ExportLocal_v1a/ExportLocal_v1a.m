%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ExportLocal_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Image
%---------------------------------------------
global TOTALGBL
val = get(findobj('tag','totalgbl'),'value');
if isempty(val) || val == 0
    err.flag = 1;
    err.msg = 'No Image in Global Memory';
    return  
end
IMG = TOTALGBL{2,val};
imagename = TOTALGBL{1,val};

%---------------------------------------------
% Get Input
%---------------------------------------------
EXPORT.method = SCRPTGBL.CurrentScript.Func;
EXPORT.exportfunc = SCRPTGBL.CurrentTree.('ExportImagefunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
EFipt = SCRPTGBL.CurrentTree.('ExportImagefunc');
if isfield(SCRPTGBL,('ExportImagefunc_Data'))
    EFipt.ImportEFfunc_Data = SCRPTGBL.ImportEFfunc_Data;
end

%------------------------------------------
% Get Export Function Info
%------------------------------------------
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
INPUT.imagename = imagename;
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

