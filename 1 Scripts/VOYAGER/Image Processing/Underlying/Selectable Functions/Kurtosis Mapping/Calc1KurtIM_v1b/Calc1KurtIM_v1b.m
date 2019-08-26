%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CalcKurtIM_v3c(SCRPTipt,SCRPTGBL)

Status('busy','Calculate Mean Kurtosis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File_Data'))
    err.flag = 1;
    err.msg = '(Re) Load Image_File';
    ErrDisp(err);
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
KURT.script = SCRPTGBL.CurrentTree.Func;

%---------------------------------------------
% Get Image
%---------------------------------------------
IMAT = SCRPTGBL.Image_File_Data.IMAT;

%---------------------------------------------
% Consolidate Dicom into Matrix
%---------------------------------------------
func = str2func([KURT.script,'_Func']);
INPUT.KURT = KURT;
INPUT.IMAT = IMAT;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Saved Structure
%--------------------------------------------
IMAT = OUTPUT.IMAT;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {IMAT};
SCRPTGBL.RWSUI.SaveVariableNames = 'IMAT';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'IMAT';


