%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = FilterImage_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Filter Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Clear Naming
%---------------------------------------------
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FILTIM.method = SCRPTGBL.CurrentTree.Func;
FILTIM.filterfunc = SCRPTGBL.CurrentTree.('Filtfunc').Func;

%---------------------------------------------
% Load Image
%---------------------------------------------
Im = SCRPTGBL.Image_File_Data.IMG.Im;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FILTipt = SCRPTGBL.CurrentTree.('Filtfunc');
if isfield(SCRPTGBL,('Filtfunc_Data'))
    FILTipt.Filtfunc_Data = SCRPTGBL.Filtfunc_Data;
end

%------------------------------------------
% Get Filter Function Info
%------------------------------------------
func = str2func(FILTIM.filterfunc);           
[SCRPTipt,FILT,err] = func(SCRPTipt,FILTipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([FILTIM.method,'_Func']);
INPUT.Im = Im;
INPUT.FILT = FILT;
[FILTIM,err] = func(FILTIM,INPUT);
if err.flag
    return
end

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(indnum).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {FILTIM};
SCRPTGBL.RWSUI.SaveVariableNames = 'FILTIM';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

