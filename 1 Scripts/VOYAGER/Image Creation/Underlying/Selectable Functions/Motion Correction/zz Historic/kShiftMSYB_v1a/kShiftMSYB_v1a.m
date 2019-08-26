%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = kShiftMSYB_v1a(SCRPTipt,MOTCORipt)

Status2('busy','kShift (Motion) Correction for MSYB',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = MOTCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MOTCOR.trajmax = str2double(MOTCORipt.('TrajMax'));
MOTCOR.gridfunc = MOTCORipt.('Gridfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = MOTCORipt.('Gridfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('Gridfunc_Data');
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
% Return
%------------------------------------------
MOTCOR.GRD = GRD;

Status2('done','',2);
Status2('done','',3);

