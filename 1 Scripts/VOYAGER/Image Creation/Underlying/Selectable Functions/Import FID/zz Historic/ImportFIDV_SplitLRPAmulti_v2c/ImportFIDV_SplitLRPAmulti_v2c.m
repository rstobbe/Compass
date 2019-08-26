%=========================================================
% (v2c)
%       - RF spoil input change
%=========================================================

function [SCRPTipt,FID,err] = ImportFIDV_SplitLRPAmulti_v2c(SCRPTipt,FIDipt)

Status2('busy','Load FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

FID = struct();
CallingLabel = FIDipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(FIDipt,[CallingLabel,'_Data']))
    if isfield(FIDipt.('FIDpath').Struct,'selectedfile')
        file = FIDipt.('FIDpath').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load FIDpath';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            FIDipt.([CallingLabel,'_Data']).('FIDpath_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load FIDpath';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.path = FIDipt.([CallingLabel,'_Data']).('FIDpath_Data').path;

Status2('done','',2);
Status2('done','',3);




