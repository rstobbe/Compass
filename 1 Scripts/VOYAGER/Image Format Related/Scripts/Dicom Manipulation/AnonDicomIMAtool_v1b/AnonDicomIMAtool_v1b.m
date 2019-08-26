%====================================================
% (v1b)
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = Anonomize_Dicom_v1b(SCRPTipt,SCRPTGBL)

Status('busy','Anonomize Dicoms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(SCRPTGBL,'Directory_Data'))
    if isfield(SCRPTGBL.CurrentTree.('Directory').Struct,'selectedfile')
        file = SCRPTGBL.CurrentTree.('Directory').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Directory';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            SCRPTGBL.('Directory_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Directory';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Input
%---------------------------------------------
ANON.method = SCRPTGBL.CurrentTree.Func;
ANON.dir = SCRPTGBL.('Directory_Data').path;
ANON.replacestring = SCRPTGBL.CurrentTree.('ReplaceString');
ANON.val = SCRPTGBL.CurrentTree.('AnonVal');

%---------------------------------------------
% Anonomize Files
%---------------------------------------------
func = str2func([ANON.method,'_Func']);
INPUT = [];
[ANON,err] = func(INPUT,ANON);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);