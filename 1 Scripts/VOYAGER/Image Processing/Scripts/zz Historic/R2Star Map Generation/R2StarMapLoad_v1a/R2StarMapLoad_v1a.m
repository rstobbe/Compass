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
MAPGEN.method = SCRPTGBL.CurrentTree.Func;
MAPGEN.calcfunc = SCRPTGBL.CurrentTree.('CalcTypefunc').Func;
MAPGEN.visuals = SCRPTGBL.CurrentTree.('Visuals');

%---------------------------------------------
% Load Image
%---------------------------------------------
IM0 = SCRPTGBL.Image_File_Data.IMG;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CALTipt = SCRPTGBL.CurrentTree.('CalcTypefunc');
if isfield(SCRPTGBL,('CalcTypefunc_Data'))
    CALTipt.Calcfunc_Data = SCRPTGBL.Calcfunc_Data;
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(MAPGEN.calcfunc);           
[SCRPTipt,CALT,err] = func(SCRPTipt,CALTipt);
if err.flag
    return
end

%---------------------------------------------
% 
%---------------------------------------------
func = str2func([MAPGEN.method,'_Func']);
INPUT.IM0 = IM0;
INPUT.CALT = CALT;
[MAPGEN,err] = func(MAPGEN,INPUT);
if err.flag
    return
end
IMG = MAPGEN.IMG;

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

