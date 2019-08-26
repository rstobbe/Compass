%=========================================================
% (v1b) 
%      - load / export options
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ConvertImage_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Image_File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Image_File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Image_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('Image_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Image_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
CVT.script = SCRPTGBL.CurrentTree.Func;
CVT.loadmeth = SCRPTGBL.CurrentTree.Loadfunc.Func;
CVT.exportmeth = SCRPTGBL.CurrentTree.Exportfunc.Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LOADipt = SCRPTGBL.CurrentTree.('Loadfunc');
if isfield(SCRPTGBL,('Loadfunc_Data'))
    LOADipt.Loadfunc_Data = SCRPTGBL.Loadfunc_Data;
end

EXPORTipt = SCRPTGBL.CurrentTree.('Exportfunc');
if isfield(SCRPTGBL,('Exportfunc_Data'))
    EXPORTipt.Exportfunc_Data = SCRPTGBL.Exportfunc_Data;
end

%------------------------------------------
% Get Load Function Info
%------------------------------------------
func = str2func(CVT.loadmeth);           
[SCRPTipt,LOAD,err] = func(SCRPTipt,LOADipt);
if err.flag
    return
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
% Convert Image
%---------------------------------------------
func = str2func([CVT.script,'_Func']);
INPUT.LOAD = LOAD;
INPUT.EXPORT = EXPORT;
[OUTPUT,err] = func(INPUT,CVT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'mo';

