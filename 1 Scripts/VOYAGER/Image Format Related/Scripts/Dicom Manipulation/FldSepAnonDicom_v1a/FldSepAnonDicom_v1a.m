%====================================================
% (v1a)
%
%====================================================

function [SCRPTipt,SCRPTGBL,err] = FldSepAnonDicom_v1a(SCRPTipt,SCRPTGBL)

Status('busy','Get Dicom Info');
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
FSEP.method = SCRPTGBL.CurrentTree.Func;
FSEP.path = SCRPTGBL.('Directory_Data').path;
FSEP.anonfunc = SCRPTGBL.CurrentTree.('Anonfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
ANONipt = SCRPTGBL.CurrentTree.('Anonfunc');
if isfield(SCRPTGBL,('Anonfunc_Data'))
    ANONipt.Anonfunc_Data = SCRPTGBL.Anonfunc_Data;
end

%------------------------------------------
% Get Anonomize Function Info
%------------------------------------------
func = str2func(FSEP.anonfunc);           
[SCRPTipt,ANON,err] = func(SCRPTipt,ANONipt);
if err.flag
    return
end

%---------------------------------------------
% Anonomize Files
%---------------------------------------------
func = str2func([FSEP.method,'_Func']);
INPUT = [];
INPUT.ANON = ANON;
[FSEP,err] = func(INPUT,FSEP);
if err.flag
    return
end

Status('done','');
Status2('done','',2);
Status2('done','',3);