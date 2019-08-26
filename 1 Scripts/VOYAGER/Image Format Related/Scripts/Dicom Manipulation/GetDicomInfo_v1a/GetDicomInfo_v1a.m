%====================================================
% (v1b)
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = GetDicomInfo_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Dicom Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'File_Data'))
    if isfield(SCRPTGBL.CurrentTree.('File').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
INFO.method = SCRPTGBL.CurrentTree.Func;
INFO.file = SCRPTGBL.('File_Data').file;

%---------------------------------------------
% Anonomize Files
%---------------------------------------------
func = str2func([INFO.method,'_Func']);
INPUT = [];
[INFO,err] = func(INPUT,INFO);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);