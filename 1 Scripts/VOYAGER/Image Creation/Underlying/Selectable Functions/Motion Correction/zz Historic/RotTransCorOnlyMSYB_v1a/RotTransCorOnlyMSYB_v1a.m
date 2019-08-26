%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = RotTransCorOnlyMSYB_v1a(SCRPTipt,MOTCORipt)

Status2('busy','Rotation and Translation Correction for MSYB',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = MOTCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MOTCOR.method = MOTCORipt.Func;
MOTCOR.trajmax = str2double(MOTCORipt.('TrajMax'));
MOTCOR.imagefunc = MOTCORipt.('Imagefunc').Func;
MOTCOR.rottranscorfunc = MOTCORipt.('RotTransCorfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMGipt = MOTCORipt.('Imagefunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'Imagefunc_Data')
        IMGipt.('Imagefunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('Imagefunc_Data');
    end
end
ROTTRANSCORipt = MOTCORipt.('RotTransCorfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'RotTransCorfunc_Data')
        ROTTRANSCORipt.('RotTransCorfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('RotTransCorfunc_Data');
    end
end

%------------------------------------------
% Get Image Creation Info
%------------------------------------------
func = str2func(MOTCOR.imagefunc);           
[SCRPTipt,IMG,err] = func(SCRPTipt,IMGipt);
if err.flag
    return
end

%------------------------------------------
% Get Rotation Correction Info
%------------------------------------------
func = str2func(MOTCOR.rottranscorfunc);           
[SCRPTipt,ROTTRANSCOR,err] = func(SCRPTipt,ROTTRANSCORipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MOTCOR.IMG = IMG;
MOTCOR.ROTTRANSCOR = ROTTRANSCOR;

Status2('done','',2);
Status2('done','',3);

