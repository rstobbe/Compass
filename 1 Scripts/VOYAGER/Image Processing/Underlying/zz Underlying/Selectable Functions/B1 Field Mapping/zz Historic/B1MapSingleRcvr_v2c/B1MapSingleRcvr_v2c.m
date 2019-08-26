%=========================================================
% (v1c) 
%       - fiddle
%=========================================================

function [SCRPTipt,B1MAP,err] = B1MapSingleRcvr_v2c(SCRPTipt,B1MAPipt)

Status2('done','B1 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B1MAP.method = B1MAPipt.Func;
B1MAP.maskval = str2double(B1MAPipt.('Mask'));
B1MAP.lpassfunc = B1MAPipt.('LowPassfunc').Func;

CallingLabel = B1MAPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LPASSipt = B1MAPipt.('LowPassfunc');
if isfield(B1MAPipt,([CallingLabel,'_Data']))
    if isfield(B1MAPipt.([CallingLabel,'_Data']),'LowPassfunc_Data')
        LPASSipt.('LowPassfunc_Data') = B1MAPipt.([CallingLabel,'_Data']).('LowPassfunc_Data');
    end
end

%------------------------------------------
% Get Plotting Info
%------------------------------------------
func = str2func(B1MAP.lpassfunc);           
[SCRPTipt,LPASS,err] = func(SCRPTipt,LPASSipt);
if err.flag
    return
end

B1MAP.LPASS = LPASS;

Status2('done','',2);
Status2('done','',3);


