%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = RotCorOnlyMSYB_v1a(SCRPTipt,MOTCORipt)

Status2('busy','Rotation Correction for MSYB',2);
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
MOTCOR.rotcorfunc = MOTCORipt.('RotCorfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMGipt = MOTCORipt.('Imagefunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'Imagefunc_Data')
        IMGipt.('Imagefunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('Imagefunc_Data');
    end
end
ROTCORipt = MOTCORipt.('RotCorfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'RotCorfunc_Data')
        ROTCORipt.('RotCorfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('RotCorfunc_Data');
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
func = str2func(MOTCOR.rotcorfunc);           
[SCRPTipt,ROTCOR,err] = func(SCRPTipt,ROTCORipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MOTCOR.IMG = IMG;
MOTCOR.ROTCOR = ROTCOR;

Status2('done','',2);
Status2('done','',3);

