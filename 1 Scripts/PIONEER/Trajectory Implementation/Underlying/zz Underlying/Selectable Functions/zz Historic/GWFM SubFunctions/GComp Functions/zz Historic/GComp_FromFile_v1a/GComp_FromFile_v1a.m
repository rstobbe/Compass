%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,GECC,err] = GECC_FromFile_v1a(SCRPTipt,GECCipt)

Status2('busy','Get ECC Infro',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GECC.method = GECCipt.Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = GECCipt.Struct.labelstr;
if not(isfield(GECCipt,[CallingLabel,'_Data']))
    if isfield(GECCipt.('LECC_File').Struct,'selectedfile')
        file = GECCipt.('LECC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load LECC_File';
            ErrDisp(err);
            return
        else
            load(file);
            GECCipt.([CallingLabel,'_Data']).('LECC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load LECC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GECC.LECC = GECCipt.([CallingLabel,'_Data']).('LECC_File_Data').LECC;

Status2('done','',2);
Status2('done','',3);