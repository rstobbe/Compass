%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = TranskShiftFollowMSYB_v1a(SCRPTipt,MOTCORipt)

Status2('busy','Translational Correction for MSYB',2);
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
MOTCOR.transcorfunc = MOTCORipt.('TransCorfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = MOTCORipt.('Gridfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
TRANSCORipt = MOTCORipt.('TransCorfunc');
if isfield(MOTCORipt,([CallingLabel,'_Data']))
    if isfield(MOTCORipt.([CallingLabel,'_Data']),'TransCorfunc_Data')
        TRANSCORipt.('TransCorfunc_Data') = MOTCORipt.([CallingLabel,'_Data']).('TransCorfunc_Data');
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
% Get Translation Correction Info
%------------------------------------------
func = str2func(MOTCOR.transcorfunc);           
[SCRPTipt,TRANSCOR,err] = func(SCRPTipt,TRANSCORipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MOTCOR.GRD = GRD;
MOTCOR.TRANSCOR = TRANSCOR;

Status2('done','',2);
Status2('done','',3);
