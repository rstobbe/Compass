%===========================================
% (v1g)
%       - Plot Update (Drop Function)
%===========================================

function [SCRPTipt,SCRPTGBL,CALB0SHIM,err] = CalB0SphH_v1g(SCRPTipt,SCRPTGBL,CALB0SHIMipt)

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
% Return
%------------------------------------------
CALB0SHIM.FIT = FIT;
CALB0SHIM.MAP = MAP;

Status2('done','',2);
Status2('done','',3);

