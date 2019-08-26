%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = B1map2angle_v1a(SCRPTipt,SCRPTGBL)


Status('busy','Image Subraction-Based Comparison');
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
% Tests
%---------------------------------------------


%---------------------------------------------
% Load Input
%---------------------------------------------
COR.script = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Load Images
%---------------------------------------------
B1map = SCRPTGBL.B1map_File_Data.B1MAP.Im;
Im = SCRPTGBL.Image_File_Data.IMG.Im;

%---------------------------------------------
% Correct DWI Image
%---------------------------------------------
func = str2func([COR.script,'_Func']);
INPUT.B1map = B1map;
INPUT.Im = Im;
[COR,err] = func(COR,INPUT);
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

SCRPTGBL.RWSUI.SaveVariables = {COR};
SCRPTGBL.RWSUI.SaveVariableNames = 'COR';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = name;

Status('done','');
Status2('done','',2);
Status2('done','',3);