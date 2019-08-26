%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TRANSCOR,err] = TransCorMSYB_v1a(SCRPTipt,TRANSCORipt)

Status2('busy','Translational Correction for MSYB',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = TRANSCORipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TRANSCOR.method = TRANSCORipt.Func;
TRANSCOR.trajmax = str2double(TRANSCORipt.('TrajMax'));
TRANSCOR.gridfunc = TRANSCORipt.('Gridfunc').Func;
TRANSCOR.transcorregfunc = TRANSCORipt.('TransCorRegfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GRDipt = TRANSCORipt.('Gridfunc');
if isfield(TRANSCORipt,([CallingLabel,'_Data']))
    if isfield(TRANSCORipt.([CallingLabel,'_Data']),'Gridfunc_Data')
        GRDipt.('Gridfunc_Data') = TRANSCORipt.([CallingLabel,'_Data']).('Gridfunc_Data');
    end
end
TRANSCORREGipt = TRANSCORipt.('TransCorRegfunc');
if isfield(TRANSCORipt,([CallingLabel,'_Data']))
    if isfield(TRANSCORipt.([CallingLabel,'_Data']),'TransCorRegfunc_Data')
        TRANSCORREGipt.('TransCorRegfunc_Data') = TRANSCORipt.([CallingLabel,'_Data']).('TransCorRegfunc_Data');
    end
end

%------------------------------------------
% Get Gridding Info
%------------------------------------------
func = str2func(TRANSCOR.gridfunc);           
[SCRPTipt,GRD,err] = func(SCRPTipt,GRDipt);
if err.flag
    return
end

%------------------------------------------
% Get Translation Correction Info
%------------------------------------------
func = str2func(TRANSCOR.transcorregfunc);           
[SCRPTipt,TRANSCORREG,err] = func(SCRPTipt,TRANSCORREGipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
TRANSCOR.GRD = GRD;
TRANSCOR.TRANSCORREG = TRANSCORREG;

Status2('done','',2);
Status2('done','',3);
