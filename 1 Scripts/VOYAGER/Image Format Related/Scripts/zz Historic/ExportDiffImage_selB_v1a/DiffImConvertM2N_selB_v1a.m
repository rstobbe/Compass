%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = DiffImConvertM2N_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Convert Matrix into Nifti');
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
CVT.script = SCRPTGBL.CurrentTree.Func;
CVT.exportmeth = SCRPTGBL.CurrentTree.Exportfunc.Func;

%---------------------------------------------
% Get Image
%---------------------------------------------
IM = SCRPTGBL.Image_File_Data.IMAT;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
EXPORTipt = SCRPTGBL.CurrentTree.('Exportfunc');
if isfield(SCRPTGBL,('Exportfunc_Data'))
    EXPORTipt.Exportfunc_Data = SCRPTGBL.Exportfunc_Data;
end

%------------------------------------------
% Get Export Function Info
%------------------------------------------
func = str2func(CVT.exportmeth);           
[SCRPTipt,EXPORT,err] = func(SCRPTipt,EXPORTipt);
if err.flag
    return
end

%---------------------------------------------
% Convert Matrix into Nifti
%---------------------------------------------
func = str2func([CVT.script,'_Func']);
INPUT.CVT = CVT;
INPUT.EXPORT = EXPORT;
INPUT.IM = IM;
[OUTPUT,err] = func(INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------------
% Return
%--------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'no';

Status('done','');
Status2('done','',2);
Status2('done','',3);




