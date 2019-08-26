%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,OBCALC,err] = CalcManipNEISEF2PSF_v1a(SCRPTipt,OBCALCipt)

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
    if isfield(OBCALCipt.('PSFob_File').Struct,'selectedfile')
        file = OBCALCipt.('PSFob_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFob File';
            ErrDisp(err);
            return
        else
            OBCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFob File';
        ErrDisp(err);
        return
    end
end
if not(isfield(OBCALCipt,[CallingLabel,'_Data']))
    if isfield(OBCALCipt.('PSFbg_File').Struct,'selectedfile')
        file = OBCALCipt.('PSFbg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFbg File';
            ErrDisp(err);
            return
        else
            OBCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFbg File';
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
OBCALC.cvcalcfunc = OBCALCipt.('CVcalcfunc').Func; 
OBCALC.roifunc = OBCALCipt.('RoiManipfunc').Func; 
if not(isfield(OBCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
OBCALC.PSFob = OBCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data').PSF;
if not(isfield(OBCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
OBCALC.PSFbg = OBCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data').PSF;
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
CVCALCipt = OBCALCipt.('CVcalcfunc');
if isfield(OBCALC,([CallingFunction,'_Data']))
    if isfield(OBCALCipt.OBCALCfunc_Data,('CVcalcfunc_Data'))
        CVCALCipt.CVcalcfunc_Data = OBCALCipt.OBCALCfunc_Data.CVcalcfunc_Data;
    end
end
ROIMANIPipt = OBCALCipt.('RoiManipfunc');
if isfield(OBCALC,([CallingFunction,'_Data']))
    if isfield(OBCALCipt.OBCALCfunc_Data,('RoiManipfunc_Data'))
        ROIMANIPipt.RoiManipfunc_Data = OBCALCipt.OBCALCfunc_Data.RoiManipfunc_Data;
    end
end

%------------------------------------------
% Function Info
%------------------------------------------
func = str2func(OBCALC.cvcalcfunc);           
[SCRPTipt,CVCALC,err] = func(SCRPTipt,CVCALCipt);
if err.flag
    return
end
func = str2func(OBCALC.roifunc);           
[SCRPTipt,ROIMANIP,err] = func(SCRPTipt,ROIMANIPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
OBCALC.CVCALC = CVCALC;
OBCALC.ROIMANIP = ROIMANIP;

Status2('done','',2);
Status2('done','',3);
