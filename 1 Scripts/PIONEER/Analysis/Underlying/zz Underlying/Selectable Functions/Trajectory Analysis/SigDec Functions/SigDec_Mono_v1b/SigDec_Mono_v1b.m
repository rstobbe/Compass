%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SDEC,err] = SigDec_Mono_v1b(SCRPTipt,SDECipt)

Status2('done','Mono Signal Decay Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SDEC.method = SDECipt.Func;
SDEC.T2 = str2double(SDECipt.('T2'));


Status2('done','',2);
Status2('done','',3);
