%===========================================
% (v1c)
%    - min/max input
%===========================================

function [SCRPTipt,ISHIM,err] = ShimImageIntensitySphH_v1c(SCRPTipt,ISHIMipt)

Status2('done','Intensity Shim Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = ISHIMipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
ISHIM.method = ISHIMipt.Func;
ISHIM.relminval = str2double(ISHIMipt.('RelMinVal'));
ISHIM.relmaxval = str2double(ISHIMipt.('RelMaxVal'));
ISHIM.maskfunc = ISHIMipt.('Maskfunc').Func;
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
MASKipt = ISHIMipt.('Maskfunc');
if isfield(ISHIMipt,([CallingLabel,'_Data']))
    if isfield(ISHIMipt.([CallingLabel,'_Data']),'Maskfunc_Data')
        MASKipt.('Maskfunc_Data') = ISHIMipt.([CallingLabel,'_Data']).('Maskfunc_Data');
    end
end

%------------------------------------------
% Get Info
%------------------------------------------
func = str2func(ISHIM.maskfunc);           
[SCRPTipt,MASK,err] = func(SCRPTipt,MASKipt);
if err.flag
    return
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
ISHIM.MASK = MASK;

Status2('done','',2);
Status2('done','',3);

