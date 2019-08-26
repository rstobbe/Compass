%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,MAP,err] = qMTmap_v1a(SCRPTipt,MAPipt)

Status2('done','MAPmap Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

CallingLabel = MAPipt.Struct.labelstr;
%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;
MAP.simfunc = MAPipt.('Simfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SIMipt = MAPipt.('Simfunc');
if isfield(MAPipt,([CallingLabel,'_Data']))
    if isfield(MAPipt.([CallingLabel,'_Data']),'Simfunc_Data')
        SIMipt.('Simfunc_Data') = MAPipt.([CallingLabel,'_Data']).('Simfunc_Data');
    end
end

%------------------------------------------
% Get Fitting Info
%------------------------------------------
func = str2func(MAP.simfunc);           
[SCRPTipt,SIM,err] = func(SCRPTipt,SIMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
MAP.SIM = SIM;

