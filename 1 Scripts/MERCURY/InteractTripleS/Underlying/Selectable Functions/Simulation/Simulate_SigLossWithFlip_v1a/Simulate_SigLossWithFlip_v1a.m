%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,SIM,err] = Simulate_SigLossWithFlip_v1a(SCRPTipt,SIMipt)

Status2('busy','Simulate Model',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SIM.method = SIMipt.Func;
SIM.modnum = str2double(SIMipt.('ModelNum'));

Status2('done','',2);
Status2('done','',3);