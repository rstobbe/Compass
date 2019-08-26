%===========================================
% (v1f)
%       - General 'Cleanup'
%===========================================

function [SCRPTipt,SCRPTGBL,CALB0SHIM,err] = CalB0SphH_v1f(SCRPTipt,SCRPTGBL,CALB0SHIMipt)

Status2('done','B0 Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = CALB0SHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CALB0SHIM.method = CALB0SHIMipt.Func;
CALB0SHIM.maxoff = str2double(CALB0SHIMipt.('MaxOffRes'));
CALB0SHIM.fitfunc = CALB0SHIMipt.('Fitfunc').Func;
CALB0SHIM.dispfunc = CALB0SHIMipt.('Dispfunc').Func;
CALB0SHIM.mapfunc = CALB0SHIMipt.('B0Mapfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = CALB0SHIMipt.('Fitfunc');
if isfield(CALB0SHIMipt,([CallingLabel,'_Data']))
    if isfield(CALB0SHIMipt.([CallingLabel,'_Data']),'Fitfunc_Data')
        FITipt.('Fitfunc_Data') = CALB0SHIMipt.([CallingLabel,'_Data']).('Fitfunc_Data');
    end
end
MAPipt = CALB0SHIMipt.('B0Mapfunc');
if isfield(CALB0SHIMipt,([CallingLabel,'_Data']))
    if isfield(CALB0SHIMipt.([CallingLabel,'_Data']),'B0Mapfunc_Data')
        MAPipt.('B0Mapfunc_Data') = CALB0SHIMipt.([CallingLabel,'_Data']).('B0Mapfunc_Data');
    end
end
DISPipt = CALB0SHIMipt.('Dispfunc');
if isfield(CALB0SHIMipt,([CallingLabel,'_Data']))
    if isfield(CALB0SHIMipt.([CallingLabel,'_Data']),'Dispfunc_Data')
        DISPipt.('Dispfunc_Data') = CALB0SHIMipt.([CallingLabel,'_Data']).('Dispfunc_Data');
    end
end

%------------------------------------------
% Get Fitting Info
%------------------------------------------
func = str2func(CALB0SHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end

%------------------------------------------
% Get Mapping Info
%------------------------------------------
func = str2func(CALB0SHIM.mapfunc);           
[SCRPTipt,MAP,err] = func(SCRPTipt,MAPipt);
if err.flag
    return
end

%------------------------------------------
% Get Display Info
%------------------------------------------
func = str2func(CALB0SHIM.dispfunc);           
[SCRPTipt,SCRPTGBL,DISP,err] = func(SCRPTipt,SCRPTGBL,DISPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CALB0SHIM.FIT = FIT;
CALB0SHIM.MAP = MAP;
CALB0SHIM.DISP = DISP;

Status2('done','',2);
Status2('done','',3);

