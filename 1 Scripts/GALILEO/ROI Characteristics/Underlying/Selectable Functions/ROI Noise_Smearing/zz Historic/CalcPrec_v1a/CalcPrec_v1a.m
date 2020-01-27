%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,PRCALC,err] = CalcPrec_v1a(SCRPTipt,PRCALCipt)

Status('busy','ROI Precision Calculation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = PRCALCipt.Struct.labelstr;
if not(isfield(PRCALCipt,[CallingLabel,'_Data']))
    if isfield(PRCALCipt.('PSD_File').Struct,'selectedfile')
        file = PRCALCipt.('PSD_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSD File';
            ErrDisp(err);
            return
        else
            PRCALCipt.([CallingLabel,'_Data']).('PSD_File_Data').file = file;
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
PRCALC.method = PRCALCipt.Func;
PRCALC.sdvnoise = str2double(PRCALCipt.('SdvNoise'));
PRCALC.sivinroifunc = PRCALCipt.('SIVinROIfunc').Func; 
if not(isfield(PRCALCipt.('CalcPrecfunc_Data').('PSD_File_Data'),'PSD'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSD struct';
    return
end
PRCALC.PSD = PRCALCipt.('CalcPrecfunc_Data').('PSD_File_Data').PSD;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = PRCALCipt.Struct.labelstr;
SIVipt = PRCALCipt.('SIVinROIfunc');
if isfield(PRCALC,([CallingFunction,'_Data']))
    if isfield(PRCALCipt.PRCALCfunc_Data,('SIVinROIfunc_Data'))
        SIVipt.SIVinROIfunc_Data = PRCALCipt.PRCALCfunc_Data.SIVinROIfunc_Data;
    end
end

%------------------------------------------
% PSD Function Info
%------------------------------------------
func = str2func(PRCALC.sivinroifunc);           
[SCRPTipt,SIV,err] = func(SCRPTipt,SIVipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
PRCALC.SIV = SIV;

Status2('done','',2);
Status2('done','',3);
