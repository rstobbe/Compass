%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = kShiftCorMSYB_v1a(SCRPTipt,MOTCORipt)

Status2('busy','kShift (Motion) Correction for MSYB',2);
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
% Return
%------------------------------------------
MOTCOR.GRD = GRD;
MOTCOR.KSHFTCOR = KSHFTCOR;

Status2('done','',2);
Status2('done','',3);

