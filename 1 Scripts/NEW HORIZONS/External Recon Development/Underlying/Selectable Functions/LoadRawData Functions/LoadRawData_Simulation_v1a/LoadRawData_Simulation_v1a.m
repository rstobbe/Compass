%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,LOAD,err] = LoadRawData_Simulation_v1a(SCRPTipt,LOADipt)

Status2('busy','Load Simulation Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

LOAD = struct();
CallingLabel = LOADipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
if not(isfield(LOADipt,[CallingLabel,'_Data']))
    if isfield(LOADipt.('Samp_File').Struct,'selectedfile')
        file = LOADipt.('Samp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Samp_File';
            ErrDisp(err);
            return
        else
            load(file);
            saveData.path = file;
            LOADipt.([CallingLabel,'_Data']).('Samp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Samp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
LOAD.method = LOADipt.Func;
LOAD.DatName = LOADipt.('Samp_File').EntryStr;
LOAD.SAMP = LOADipt.([CallingLabel,'_Data']).('Samp_File_Data').SAMP;
LOAD.path = LOADipt.([CallingLabel,'_Data']).('Samp_File_Data').path;
LOAD.ReconPars = [];

Status2('done','',2);
Status2('done','',3);
