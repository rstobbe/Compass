%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,IC,ReturnData,err] = ImpLoadCombined_v1a(SCRPTipt,ICipt)

Status2('busy','Get Info for Image Creation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

IC = struct();
ReturnData = struct();
CallingLabel = ICipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(ICipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Recon_File_Data'))
    if isfield(ICipt.('Recon_File').Struct,'selectedfile')
        file = ICipt.('Recon_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Recon_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Reconstruction Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('Recon_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Recon_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.IMP = ICipt.([CallingLabel,'_Data']).('Recon_File_Data').IMP;

%---------------------------------------------
% Return
%---------------------------------------------
ReturnData.('Recon_File_Data') = ICipt.([CallingLabel,'_Data']).('Recon_File_Data');


Status2('done','',2);
Status2('done','',3);

