%===========================================
% (v1a)
%       
%===========================================

function [SCRPTipt,SHIM,err] = CalB0SphHComp_v1a(SCRPTipt,SHIMipt)

Status2('done','Compare Calibrations',2);
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
if LoadAll == 1 || not(isfield(SHIMipt.([CallingLabel,'_Data']),'Cal_File1_Data'))
    if isfield(SHIMipt.('Cal_File1').Struct,'selectedfile')
        file = SHIMipt.('Cal_File1').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Cal_File1';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Calibration Data',2);
            load(file);
            saveData.path = file;
            SHIMipt.([CallingLabel,'_Data']).('Cal_File1_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Cal_File1';
        ErrDisp(err);
        return
    end
    if isfield(SHIMipt.('Cal_File2').Struct,'selectedfile')
        file = SHIMipt.('Cal_File2').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load Cal_File2';
            ErrDisp(err);
            return
        else
            Status2('busy','Load Calibration Data',2);
            load(file);
            saveData.path = file;
            SHIMipt.([CallingLabel,'_Data']).('Cal_File2_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load Cal_File2';
        ErrDisp(err);
        return
    end    
end

%------------------------------------------
% Return
%------------------------------------------
SHIM.CalData1 = SHIMipt.([CallingLabel,'_Data']).('Cal_File1_Data').CAL.CalData;
SHIM.CalData2 = SHIMipt.([CallingLabel,'_Data']).('Cal_File2_Data').CAL.CalData;

Status2('done','',2);
Status2('done','',3);

