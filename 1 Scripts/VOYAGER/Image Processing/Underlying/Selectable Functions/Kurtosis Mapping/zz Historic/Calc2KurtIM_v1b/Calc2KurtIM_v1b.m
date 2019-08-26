%=========================================================
% (v1b) 
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = Calc2KurtIM_v1b(SCRPTipt,SCRPTGBL)

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
% Clear Naming
%---------------------------------------------
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
KURT.script = SCRPTGBL.CurrentTree.Func;
KURT.constrain = SCRPTGBL.CurrentTree.('Constrain');
KURT.minvalonb0 = SCRPTGBL.CurrentTree.('MinVal_b0');

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
KURT = OUTPUT.KURT;
KURT.MK = OUTPUT.MK;
KURT.MD = OUTPUT.MD;

%--------------------------------------------
% Return
%--------------------------------------------
name = inputdlg('Name Image:');
if isempty(name)
    SCRPTGBL.RWSUI.SaveGlobal = 'no';
    return
end
SCRPTipt(strcmp('Image_Name',{SCRPTipt.labelstr})).entrystr = cell2mat(name);

SCRPTGBL.RWSUI.SaveVariables = {KURT};
SCRPTGBL.RWSUI.SaveVariableNames = 'KURT';
SCRPTGBL.RWSUI.SaveGlobal = 'yes';
SCRPTGBL.RWSUI.SaveGlobalNames = name;
SCRPTGBL.RWSUI.SaveScriptOption = 'yes';
SCRPTGBL.RWSUI.SaveScriptPath = 'outloc';
SCRPTGBL.RWSUI.SaveScriptName = 'KURT';

Status('done','');
Status2('done','',2);
Status2('done','',3);
