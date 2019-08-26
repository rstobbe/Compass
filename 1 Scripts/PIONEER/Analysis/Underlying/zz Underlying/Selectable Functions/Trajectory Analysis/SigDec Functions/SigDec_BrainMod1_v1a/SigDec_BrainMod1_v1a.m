%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SDEC,err] = SigDec_BrainMod1_v1a(SCRPTipt,SDECipt)

Status2('done','Na Signal Decay Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SDEC.method = SDECipt.Func;

Status2('done','',2);
Status2('done','',3);
