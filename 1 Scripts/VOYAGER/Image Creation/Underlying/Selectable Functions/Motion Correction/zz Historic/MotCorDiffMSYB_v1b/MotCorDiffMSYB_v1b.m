%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = MotCorDiffMSYB_v1b(SCRPTipt,MOTCORipt)

Status2('busy','Motion Correction for MSYB Diffusion Imaging',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = MOTCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MOTCOR.method = MOTCORipt.Func;
MOTCOR.trajmax = str2double(MOTCORipt.('TrajMax'));
MOTCOR.gridfunc = MOTCORipt.('Gridfunc').Func;
MOTCOR.kshftcorfunc = MOTCORipt.('kShftCorfunc').Func;
MOTCOR.transcorfunc = MOTCORipt.('TransCorfunc').Func;
MOTCOR.imagefunc = MOTCORipt.('Imagefunc').Func;
MOTCOR.rotcorfunc = MOTCORipt.('RotCorfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = MOTCORipt.('Gridfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
KSHFTCORipt = MOTCORipt.('kShftCorfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'kShftCorfunc_Data')
        KSHFTCORipt.('kShftCorfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('kShftCorfunc_Data');
    end
end
TRANSCORipt = MOTCORipt.('TransCorfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'TransCorfunc_Data')
        TRANSCORipt.('TransCorfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('TransCorfunc_Data');
    end
end
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
% Get Gridding Info
%------------------------------------------
func = str2func(MOTCOR.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% Get kShift Correction Info
%------------------------------------------
func = str2func(MOTCOR.kshftcorfunc);           
[SCRPTipt,KSHFTCOR,err] = func(SCRPTipt,KSHFTCORipt);
if err.flag
    return
end

%------------------------------------------
% Get Translation Correction Info
%------------------------------------------
func = str2func(MOTCOR.transcorfunc);           
[SCRPTipt,TRANSCOR,err] = func(SCRPTipt,TRANSCORipt);
if err.flag
    return
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
MOTCOR.GRD = GRD;
MOTCOR.KSHFTCOR = KSHFTCOR;
MOTCOR.TRANSCOR = TRANSCOR;
MOTCOR.IMG = IMG;
MOTCOR.ROTCOR = ROTCOR;

Status2('done','',2);
Status2('done','',3);

