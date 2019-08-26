%=========================================================
% (v1b)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = CorrAbsNoise_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Correct for Effect of Absolute Value on Noise');
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
inds = strcmp('Image_Name',{SCRPTipt.labelstr});
indnum = find(inds==1);
if length(indnum) > 1
    indnum = indnum(SCRPTGBL.RWSUI.scrptnum);
end
SCRPTipt(indnum).entrystr = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
COR.script = SCRPTGBL.CurrentTree.Func;
COR.sdvnoise = str2double(SCRPTGBL.CurrentTree.sdv_noise);

%---------------------------------------------
% Get Image
%---------------------------------------------
IMAT = SCRPTGBL.Image_File_Data.IMAT;

%---------------------------------------------
% Correct DWI Image
%---------------------------------------------
func = str2func([COR.script,'_Func']);
INPUT.COR = COR;
INPUT.IMAT = IMAT;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end

%--------------------------------------------
% Saved
%--------------------------------------------
IMAT.dwims = OUTPUT.cdwims;
IMAT.COR = COR;

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

Status('done','');
Status2('done','',2);
Status2('done','',3);

