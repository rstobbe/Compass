%=========================================================
% (v1a) 
%   
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = ExportImage_v1a(SCRPTipt,SCRPTGBL)

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
% Get Input
%---------------------------------------------
EXPORT.method = SCRPTGBL.CurrentScript.Func;
EXPORT.exportfunc = SCRPTGBL.CurrentTree.('ExportImagefunc').Func;
IMG = SCRPTGBL.('Image_File_Data').IMG;
ind = strfind(SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile,'.mat');
dfilename = SCRPTGBL.CurrentTree.('Image_File').Struct.selectedfile(1:ind-1);

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
INPUT.EF = EF;
INPUT.dfilename = dfilename;
[EXPORT,err] = func(EXPORT,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
SCRPTGBL.RWSUI.SaveGlobal = 'no';
SCRPTGBL.RWSUI.SaveScriptOption = 'mo';

