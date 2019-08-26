%===========================================
% (v1c)
%       - Mask large off resonance on base
%===========================================

function [SCRPTipt,B0SHIM,err] = CalB0SphH_v1c(SCRPTipt,B0SHIMipt)

Status2('done','B0 Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = B0SHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B0SHIM.method = B0SHIMipt.Func;
B0SHIM.threshold = str2double(B0SHIMipt.('RelIntenseThrsh'));
B0SHIM.maxoff = str2double(B0SHIMipt.('MaxOffRes'));
B0SHIM.dispwid = str2double(B0SHIMipt.('DispWid'));
B0SHIM.visuals = B0SHIMipt.('Visuals');
B0SHIM.fitfunc = B0SHIMipt.('Fitfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = B0SHIMipt.('Fitfunc');
if isfield(B0SHIMipt,([CallingLabel,'_Data']))
    if isfield(B0SHIMipt.([CallingLabel,'_Data']),'Fitfunc_Data')
        FITipt.('Fitfunc_Data') = B0SHIMipt.([CallingLabel,'_Data']).('Fitfunc_Data');
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
% Return
%------------------------------------------
B0SHIM.FIT = FIT;


Status2('done','',2);
Status2('done','',3);

