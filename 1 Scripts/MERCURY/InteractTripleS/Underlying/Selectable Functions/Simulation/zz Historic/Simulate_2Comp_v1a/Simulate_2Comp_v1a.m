%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,SIM,err] = Simulate_2Comp_v1a(SCRPTipt,SIMipt)

Status2('busy','2 Compartment Simulation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SIM.method = SIMipt.Func;
SIM.fcomp1 = str2double(SIMipt.('FracComp1'))/100;

Status2('done','',2);
Status2('done','',3);