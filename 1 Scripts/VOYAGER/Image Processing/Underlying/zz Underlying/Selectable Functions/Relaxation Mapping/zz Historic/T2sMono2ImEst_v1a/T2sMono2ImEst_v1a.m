%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,MAP,err] = T2sMono2ImEst_v1a(SCRPTipt,MAPipt)

Status2('done','MAPmap Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;
MAP.maskval = str2double(MAPipt.('Mask'));
MAP.lpassfunc = MAPipt.('LowPassfunc').Func;

CallingLabel = MAPipt.Struct.labelstr;
%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
LPASSipt = MAPipt.('LowPassfunc');
if isfield(MAPipt,([CallingLabel,'_Data']))
    if isfield(MAPipt.([CallingLabel,'_Data']),'LowPassfunc_Data')
        LPASSipt.('LowPassfunc_Data') = MAPipt.([CallingLabel,'_Data']).('LowPassfunc_Data');
    end
end

%------------------------------------------
% Get Plotting Info
%------------------------------------------
func = str2func(MAP.lpassfunc);           
[SCRPTipt,LPASS,err] = func(SCRPTipt,LPASSipt);
if err.flag
    return
end

MAP.LPASS = LPASS;

Status2('done','',2);
Status2('done','',3);
