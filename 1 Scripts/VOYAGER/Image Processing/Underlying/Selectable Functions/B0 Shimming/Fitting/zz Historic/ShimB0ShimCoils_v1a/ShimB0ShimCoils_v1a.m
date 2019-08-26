%===========================================
% (v1a)
%   
%===========================================

function [SCRPTipt,SHIM,err] = ShimB0ShimCoils_v1a(SCRPTipt,SHIMipt)

Status2('done','B0 Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

SHIM = struct();
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
            Status2('busy','Load Calibration Data',2);
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
% Load Panel Input
%---------------------------------------------
SHIM.method = SHIMipt.Func;
SHIM.threshold = str2double(SHIMipt.('Threshold'));
SHIM.dispwid = str2double(SHIMipt.('DispWid'));
SHIM.visuals = SHIMipt.('Visuals');
SHIM.fitfunc = SHIMipt.('Fitfunc').Func;
SHIM.CalData = SHIMipt.([CallingLabel,'_Data']).('Cal_File_Data').CAL.CalData;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = SHIMipt.('Fitfunc');
if isfield(SHIMipt,([CallingLabel,'_Data']))
    if isfield(SHIMipt.([CallingLabel,'_Data']),'Fitfunc_Data')
        FITipt.('Fitfunc_Data') = SHIMipt.([CallingLabel,'_Data']).('Fitfunc_Data');
    end
end

%------------------------------------------
% Get Fitting Info
%------------------------------------------
func = str2func(SHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
SHIM.FIT = FIT;


Status2('done','',2);
Status2('done','',3);

