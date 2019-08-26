%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,ISHIM,err] = ShimImageIntensity_v1a(SCRPTipt,ISHIMipt)

Status2('done','Intensity Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = ISHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
ISHIM.method = ISHIMipt.Func;
ISHIM.profres = str2double(ISHIMipt.('ImProfRes'));
ISHIM.proffilt = str2double(ISHIMipt.('ImProfFilt'));
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

