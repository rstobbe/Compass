%=========================================================
% (v1b) 
%      - Compensate for Possible Image FoV Reduction
%=========================================================

function [SCRPTipt,SEFCALC,err] = CalcSEF2PSF_v1b(SCRPTipt,SEFCALCipt)

Status2('busy','Calculate Smearing Error Factor',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
SEFCALC = struct();

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = SEFCALCipt.Struct.labelstr;
if not(isfield(SEFCALCipt,[CallingLabel,'_Data']))
    if isfield(SEFCALCipt.('PSFob_File').Struct,'selectedfile')
        file = SEFCALCipt.('PSFob_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFob_File';
            ErrDisp(err);
            return
        else
            SEFCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFob_File';
        ErrDisp(err);
        return
    end
    if isfield(SEFCALCipt.('PSFbg_File').Struct,'selectedfile')
        file = SEFCALCipt.('PSFbg_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load PSFbg_File';
            ErrDisp(err);
            return
        else
            SEFCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data').file = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load PSFbg_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SEFCALC.method = SEFCALCipt.Func;
SEFCALC.ratio = str2double(SEFCALCipt.('ObSigRatio'));
if not(isfield(SEFCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
SEFCALC.PSFob = SEFCALCipt.([CallingLabel,'_Data']).('PSFob_File_Data').PSF;
if not(isfield(SEFCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data'),'PSF'))
    err.flag = 1;
    err.msg = 'Matfile Does Not Contain PSF struct';
    return
end
SEFCALC.PSFbg = SEFCALCipt.([CallingLabel,'_Data']).('PSFbg_File_Data').PSF;

Status2('done','',2);
Status2('done','',3);
