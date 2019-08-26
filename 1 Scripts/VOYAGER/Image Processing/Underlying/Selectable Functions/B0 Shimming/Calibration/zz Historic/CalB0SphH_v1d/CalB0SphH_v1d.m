%===========================================
% (v1d)
%       - Split into modules
%===========================================

function [SCRPTipt,B0SHIM,err] = CalB0SphH_v1d(SCRPTipt,B0SHIMipt)

Status2('done','B0 Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = B0SHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B0SHIM.method = B0SHIMipt.Func;
B0SHIM.maxoff = str2double(B0SHIMipt.('MaxOffRes'));
B0SHIM.fitfunc = B0SHIMipt.('Fitfunc').Func;
B0SHIM.dispfunc = B0SHIMipt.('Dispfunc').Func;
B0SHIM.mapfunc = B0SHIMipt.('B0Mapfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = B0SHIMipt.('Fitfunc');
if isfield(B0SHIMipt,([CallingLabel,'_Data']))
    if isfield(B0SHIMipt.([CallingLabel,'_Data']),'Fitfunc_Data')
        FITipt.('Fitfunc_Data') = B0SHIMipt.([CallingLabel,'_Data']).('Fitfunc_Data');
    end
end
MAPipt = B0SHIMipt.('B0Mapfunc');
if isfield(B0SHIMipt,([CallingLabel,'_Data']))
    if isfield(B0SHIMipt.([CallingLabel,'_Data']),'B0Mapfunc_Data')
        MAPipt.('B0Mapfunc_Data') = B0SHIMipt.([CallingLabel,'_Data']).('B0Mapfunc_Data');
    end
end
DISPipt = B0SHIMipt.('Dispfunc');
if isfield(B0SHIMipt,([CallingLabel,'_Data']))
    if isfield(B0SHIMipt.([CallingLabel,'_Data']),'Dispfunc_Data')
        DISPipt.('Dispfunc_Data') = B0SHIMipt.([CallingLabel,'_Data']).('Dispfunc_Data');
    end
end

%------------------------------------------
% Get Fitting Info
%------------------------------------------
func = str2func(B0SHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end

%------------------------------------------
% Get Mapping Info
%------------------------------------------
func = str2func(B0SHIM.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Info
%------------------------------------------
func = str2func(B0SHIM.dispfunc);           
[SCRPTipt,DISP,err] = func(SCRPTipt,DISPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
B0SHIM.FIT = FIT;
B0SHIM.MAP = MAP;
B0SHIM.DISP = DISP;

Status2('done','',2);
Status2('done','',3);

