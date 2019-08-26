%=========================================================
% (v1a)
%       - 
%=========================================================

function [SCRPTipt,SCRPTGBL,FID,err] = ImportFIDSim_SampDat_v1a(SCRPTipt,SCRPTGBL,FIDipt,RWSUI)

Status2('busy','Load Simulation Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

FID = struct();
CallingLabel = FIDipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(FIDipt,[CallingLabel,'_Data']))
    if isfield(FIDipt.('SampDat').Struct,'selectedfile')
        file = FIDipt.('SampDat').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SampDat';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            FIDipt.([CallingLabel,'_Data']).('SampDat_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SampDat';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FID.method = FIDipt.Func;
FID.DatName = FIDipt.('SampDat').EntryStr;
FID.SAMP = FIDipt.([CallingLabel,'_Data']).('SampDat_Data').SAMP;
FID.path = FIDipt.([CallingLabel,'_Data']).('SampDat_Data').path;
FID.ReconPars = [];

Status2('done','',2);
Status2('done','',3);

