%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SCRPTGBL,err] = R2StarMapLoad_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Create R2Star Map');
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
IMG.method = SCRPTGBL.CurrentTree.Func;
IMG.calcfunc = SCRPTGBL.CurrentTree.('Calcfunc').Func;
IMG.visuals = SCRPTGBL.CurrentTree.('Visuals');

%---------------------------------------------
% Load Image
%---------------------------------------------
IM0 = SCRPTGBL.Image_File_Data.IMG;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALCipt = SCRPTGBL.CurrentTree.('Calcfunc');
if isfield(SCRPTGBL,('Calcfunc_Data'))
    CALCipt.Calcfunc_Data = SCRPTGBL.Calcfunc_Data;
end

%------------------------------------------
% Get Shim Function Info
%------------------------------------------
func = str2func(IMG.calcfunc);           
[SCRPTipt,CALC,err] = func(SCRPTipt,CALCipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([IMG.method,'_Func']);
INPUT.IM0 = IM0;
INPUT.CALC = CALC;
[IMG,err] = func(IMG,INPUT);
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

SCRPTGBL.RWSUI.SaveVariables = {IMG};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMG';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);

