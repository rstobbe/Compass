%=========================================================
% (v1b) 
%      - Compensate for Possible Image FoV Reduction
%=========================================================

function [SCRPTipt,PSFACALC,err] = CalcSEF_v1b(SCRPTipt,PSFACALCipt)

Status2('busy','Calculate Smearing Error Factor',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
PSFACALC = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = PSFACALCipt.Struct.labelstr;
if not(isfield(PSFACALCipt,[CallingLabel,'_Data']))
    if isfield(PSFACALCipt.('PSF_File').Struct,'selectedfile')
        file = PSFACALCipt.('PSF_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSF File';
            ErrDisp(err);
            return
        else
            PSFACALCipt.([CallingLabel,'_Data']).('PSF_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSF File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSFACALC.method = PSFACALCipt.Func;
if not(isfield(PSFACALCipt.([CallingLabel,'_Data']).('PSF_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
PSFACALC.PSF = PSFACALCipt.([CallingLabel,'_Data']).('PSF_File_Data').PSF;

Status2('done','',2);
Status2('done','',3);
