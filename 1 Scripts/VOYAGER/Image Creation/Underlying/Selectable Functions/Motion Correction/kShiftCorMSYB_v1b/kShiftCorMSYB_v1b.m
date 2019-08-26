%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,KSHFTCOR,err] = kShiftCorMSYB_v1b(SCRPTipt,KSHFTCORipt)

Status2('busy','kShift (Motion) Correction for MSYB',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = KSHFTCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSHFTCOR.method = KSHFTCORipt.Func;
KSHFTCOR.trajmax = str2double(KSHFTCORipt.('TrajMax'));
KSHFTCOR.gridfunc = KSHFTCORipt.('Gridfunc').Func;
KSHFTCOR.kshftcorregfunc = KSHFTCORipt.('kShftCorRegfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = KSHFTCORipt.('Gridfunc');
if isfield(KSHFTCORipt,([CallingLabel,'_Data']))
    if isfield(KSHFTCORipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = KSHFTCORipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
KSHFTCORREGipt = KSHFTCORipt.('kShftCorRegfunc');
if isfield(KSHFTCORipt,([CallingLabel,'_Data']))
    if isfield(KSHFTCORipt.([CallingLabel,'_Data']),'kShftCorRegfunc_Data')
        KSHFTCORREGipt.('kShftCorRegfunc_Data') = KSHFTCORipt.([CallingLabel,'_Data']).('kShftCorRegfunc_Data');
    end
end

%------------------------------------------
% Get Gridding Info
%------------------------------------------
func = str2func(KSHFTCOR.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% Get kShift Correction Info
%------------------------------------------
func = str2func(KSHFTCOR.kshftcorregfunc);           
[SCRPTipt,KSHFTCORREG,err] = func(SCRPTipt,KSHFTCORREGipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
KSHFTCOR.GRD = GRD;
KSHFTCOR.KSHFTCORREG = KSHFTCORREG;

Status2('done','',2);
Status2('done','',3);

