%=========================================================
% (v1b) 
%      - use 'common' CV function 
%=========================================================

function [SCRPTipt,OBCALC,err] = CalcIRSNEI_ManipVOI_v1b(SCRPTipt,OBCALCipt)

Status2('busy','Calculate NEI and SEF.  Manipulate ROI and return mean',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OBCALC = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = OBCALCipt.Struct.labelstr;
if not(isfield(OBCALCipt,[CallingLabel,'_Data']))
    if isfield(OBCALCipt.('PSF_File').Struct,'selectedfile')
        file = OBCALCipt.('PSF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSF File';
            ErrDisp(err);
            return
        else
            OBCALCipt.([CallingLabel,'_Data']).('PSF_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSF File';
        ErrDisp(err);
        return
    end
end
if not(isfield(OBCALCipt,[CallingLabel,'_Data']))
    if isfield(OBCALCipt.('PSD_File').Struct,'selectedfile')
        file = OBCALCipt.('PSD_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSD File';
            ErrDisp(err);
            return
        else
            OBCALCipt.([CallingLabel,'_Data']).('PSD_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSD File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
OBCALC.method = OBCALCipt.Func;
OBCALC.sdvnoise = str2double(OBCALCipt.('SdvNoise'));
OBCALC.roifunc = OBCALCipt.('RoiManipfunc').Func; 
if not(isfield(OBCALCipt.([CallingLabel,'_Data']).('PSF_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
OBCALC.PSF = OBCALCipt.([CallingLabel,'_Data']).('PSF_File_Data').PSF;
if not(isfield(OBCALCipt.([CallingLabel,'_Data']).('PSD_File_Data'),'PSD'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSD struct';
    return
end
OBCALC.PSD = OBCALCipt.([CallingLabel,'_Data']).('PSD_File_Data').PSD;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = OBCALCipt.Struct.labelstr;
ROIMANIPipt = OBCALCipt.('RoiManipfunc');
if isfield(OBCALC,([CallingFunction,'_Data']))
    if isfield(OBCALCipt.OBCALCfunc_Data,('RoiManipfunc_Data'))
        ROIMANIPipt.RoiManipfunc_Data = OBCALCipt.OBCALCfunc_Data.RoiManipfunc_Data;
    end
end

%------------------------------------------
% Function Info
%------------------------------------------
func = str2func(OBCALC.roifunc);           
[SCRPTipt,ROIMANIP,err] = func(SCRPTipt,ROIMANIPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
OBCALC.ROIMANIP = ROIMANIP;

Status2('done','',2);
Status2('done','',3);
