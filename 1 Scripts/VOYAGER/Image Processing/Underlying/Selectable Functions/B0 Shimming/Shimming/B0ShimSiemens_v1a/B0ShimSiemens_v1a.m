%===========================================
% (v1a)
%   
%===========================================

function [SCRPTipt,SHIM,err] = B0ShimSiemens_v1a(SCRPTipt,SHIMipt)

Status2('done','B0 Shimming',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
SHIM.method = SHIMipt.Func;
SHIM.maskfunc = SHIMipt.('Maskfunc').Func;
SHIM.absthresh = str2double(SHIMipt.('AbsThresh'));
SHIM.freqthresh = str2double(SHIMipt.('FreqThresh'));

CallingLabel = SHIMipt.Struct.labelstr;
%---------------------------------------------
% Tests
%---------------------------------------------
LoadAll = 0;
if not(isfield(SHIMipt,[CallingLabel,'_Data']))
    LoadAll = 1;
end
if LoadAll == 1 || not(isfield(SHIMipt.([CallingLabel,'_Data']),'Cal_File_Data'))
    if isfield(SHIMipt.('Cal_File').Struct,'selectedfile')
        file = SHIMipt.('Cal_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Cal_File';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Cal Data',2);
            load(file);
            saveData.path = file;
            SHIMipt.([CallingLabel,'_Data']).('Cal_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Cal_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
MASKipt = SHIMipt.('Maskfunc');
if isfield(SHIMipt,([CallingLabel,'_Data']))
    if isfield(SHIMipt.([CallingLabel,'_Data']),'Maskfunc_Data')
        MASKipt.('Maskfunc_Data') = SHIMipt.([CallingLabel,'_Data']).('Maskfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(SHIM.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SHIM.CAL = SHIMipt.([CallingLabel,'_Data']).('Cal_File_Data').CAL;
SHIM.MASK = MASK;

Status2('done','',2);
Status2('done','',3);

