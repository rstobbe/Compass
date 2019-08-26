%=========================================================
% (v1a) 
%     
%=========================================================

function [SCRPTipt,IC,ReturnData,err] = ImpLoadSeparated_v1a(SCRPTipt,ICipt)

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
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'Imp_File_Data'))
    if isfield(ICipt.('Imp_File').Struct,'selectedfile')
        file = ICipt.('Imp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Imp_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Impstruction Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('Imp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Imp_File';
        ErrDisp(err);
        return
    end
end
if LoadAll == 1 || not(isfield(ICipt.([CallingLabel,'_Data']),'SDC_File_Data'))
    if isfield(ICipt.('SDC_File').Struct,'selectedfile')
        file = ICipt.('SDC_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load SDC_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load SDC Data',2);
            load(file);
            saveData.path = file;
            ICipt.([CallingLabel,'_Data']).('SDC_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load SDC_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.IMP = ICipt.([CallingLabel,'_Data']).('Imp_File_Data').IMP;
IC.IMP.SDCname = ICipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS.name;
IC.SDC = ICipt.([CallingLabel,'_Data']).('SDC_File_Data').SDCS.SDC;

%---------------------------------------------
% Return
%---------------------------------------------
ReturnData.('Imp_File_Data') = ICipt.([CallingLabel,'_Data']).('Imp_File_Data');
ReturnData.('SDC_File_Data') = ICipt.([CallingLabel,'_Data']).('SDC_File_Data');


Status2('done','',2);
Status2('done','',3);

