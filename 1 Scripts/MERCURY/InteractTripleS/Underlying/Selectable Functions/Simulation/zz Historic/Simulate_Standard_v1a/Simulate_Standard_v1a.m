%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,SIM,err] = Simulate_Standard_v1a(SCRPTipt,SIMipt)

Status2('busy','Standard Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SIM.method = SIMipt.Func;

Status2('done','',2);
Status2('done','',3);