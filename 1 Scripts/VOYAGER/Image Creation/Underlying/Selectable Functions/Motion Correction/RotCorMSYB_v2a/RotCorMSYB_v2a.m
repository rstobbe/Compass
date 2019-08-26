%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,ROTCOR,err] = RotCorMSYB_v2a(SCRPTipt,ROTCORipt)

Status2('busy','Correct for Rotation Between Trajectories (MSYB)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = ROTCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
ROTCOR.method = ROTCORipt.Func;
ROTCOR.trajmax = str2double(ROTCORipt.('TrajMax'));
ROTCOR.imthresh = str2double(ROTCORipt.('RelThresh'));
ROTCOR.rottol = str2double(ROTCORipt.('RotTol'));
ROTCOR.imagefunc = ROTCORipt.('Imagefunc').Func;
ROTCOR.rotcorregfunc = ROTCORipt.('RotCorRegfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
IMGipt = ROTCORipt.('Imagefunc');
if isfield(ROTCORipt,([CallingLabel,'_Data']))
    if isfield(ROTCORipt.([CallingLabel,'_Data']),'Imagefunc_Data')
        IMGipt.('Imagefunc_Data') = ROTCORipt.([CallingLabel,'_Data']).('Imagefunc_Data');
    end
end
ROTCORREGipt = ROTCORipt.('RotCorRegfunc');
if isfield(ROTCORipt,([CallingLabel,'_Data']))
    if isfield(ROTCORipt.([CallingLabel,'_Data']),'RotCorRegfunc_Data')
        ROTCORREGipt.('RotCorRegfunc_Data') = ROTCORipt.([CallingLabel,'_Data']).('RotCorRegfunc_Data');
    end
end

%------------------------------------------
% Get Image Creation Info
%------------------------------------------
func = str2func(ROTCOR.imagefunc);           
[SCRPTipt,IMG,err] = func(SCRPTipt,IMGipt);
if err.flag
    return
end

%------------------------------------------
% Get Rotation Correction Info
%------------------------------------------
func = str2func(ROTCOR.rotcorregfunc);           
[SCRPTipt,ROTCORREG,err] = func(SCRPTipt,ROTCORREGipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
ROTCOR.IMG = IMG;
ROTCOR.ROTCORREG = ROTCORREG;

Status2('done','',2);
Status2('done','',3);

