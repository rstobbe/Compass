%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,PSTP,err] = PostProc_fsemsuf_v1a(SCRPTipt,PSTPipt)

Status2('busy','Get Post Processing Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Panel Input
%---------------------------------------------
PSTP.method = PSTPipt.Func;
PSTP.ishimfunc = PSTPipt.('IntensityShimfunc').Func;
PSTP.visuals = PSTPipt.('Visuals');

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = PSTPipt.Struct.labelstr;
ISHIMipt = PSTPipt.('IntensityShimfunc');
if isfield(PSTPipt,([CallingLabel,'_Data']))
    if isfield(PSTPipt.([CallingLabel,'_Data']),'IntensityShimfunc_Data')
        ISHIMipt.('IntensityShimfunc_Data') = PSTPipt.([CallingLabel,'_Data']).('IntensityShimfunc_Data');
    end
end

%------------------------------------------
% Get IShim Function Info
%------------------------------------------
func = str2func(PSTP.ishimfunc);           
[SCRPTipt,ISHIM,err] = func(SCRPTipt,ISHIMipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSTP.ISHIM = ISHIM;

Status2('done','',2);
Status2('done','',3);







