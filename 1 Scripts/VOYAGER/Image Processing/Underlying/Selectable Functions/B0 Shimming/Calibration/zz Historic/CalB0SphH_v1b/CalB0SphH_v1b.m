%===========================================
% (v1b)
%       - display width selection
%===========================================

function [SCRPTipt,ISHIM,err] = CalB0SphH_v1b(SCRPTipt,ISHIMipt)

Status2('done','B0 Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = ISHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
ISHIM.method = ISHIMipt.Func;
ISHIM.threshold = str2double(ISHIMipt.('Threshold'));
ISHIM.dispwid = str2double(ISHIMipt.('DispWid'));
ISHIM.visuals = ISHIMipt.('Visuals');
ISHIM.fitfunc = ISHIMipt.('Fitfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
FITipt = ISHIMipt.('Fitfunc');
if isfield(ISHIMipt,([CallingLabel,'_Data']))
    if isfield(ISHIMipt.([CallingLabel,'_Data']),'Fitfunc_Data')
        FITipt.('Fitfunc_Data') = ISHIMipt.([CallingLabel,'_Data']).('Fitfunc_Data');
    end
end

%------------------------------------------
% Get Fitting Info
%------------------------------------------
func = str2func(ISHIM.fitfunc);           
[SCRPTipt,FIT,err] = func(SCRPTipt,FITipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
ISHIM.FIT = FIT;


Status2('done','',2);
Status2('done','',3);

