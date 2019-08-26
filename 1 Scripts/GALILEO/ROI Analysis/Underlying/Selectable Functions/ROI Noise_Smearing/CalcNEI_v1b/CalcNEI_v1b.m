%=========================================================
% (v1b) 
%      - Compensate for Possible Image FoV Reduction
%=========================================================

function [SCRPTipt,NPICALC,err] = CalcNEI_v1b(SCRPTipt,NPICALCipt)

Status2('busy','Calculate Noise Error Interval',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
NPICALC = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = NPICALCipt.Struct.labelstr;
if not(isfield(NPICALCipt,[CallingLabel,'_Data']))
    if isfield(NPICALCipt.('PSD_File').Struct,'selectedfile')
        file = NPICALCipt.('PSD_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSD File';
            ErrDisp(err);
            return
        else
            NPICALCipt.([CallingLabel,'_Data']).('PSD_File_Data').file = file;
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
NPICALC.method = NPICALCipt.Func;
NPICALC.sdvnoise = str2double(NPICALCipt.('SdvNoise'));
NPICALC.cvcalcfunc = NPICALCipt.('CVcalcfunc').Func; 
if not(isfield(NPICALCipt.([CallingLabel,'_Data']).('PSD_File_Data'),'PSD'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSD struct';
    return
end
NPICALC.PSD = NPICALCipt.([CallingLabel,'_Data']).('PSD_File_Data').PSD;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = NPICALCipt.Struct.labelstr;
CVCALCipt = NPICALCipt.('CVcalcfunc');
if isfield(NPICALC,([CallingFunction,'_Data']))
    if isfield(NPICALCipt.NPICALCfunc_Data,('CVcalcfunc_Data'))
        CVCALCipt.CVcalcfunc_Data = NPICALCipt.NPICALCfunc_Data.CVcalcfunc_Data;
    end
end

%------------------------------------------
% Function Info
%------------------------------------------
func = str2func(NPICALC.cvcalcfunc);           
[SCRPTipt,CVCALC,err] = func(SCRPTipt,CVCALCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
NPICALC.CVCALC = CVCALC;

Status2('done','',2);
Status2('done','',3);
