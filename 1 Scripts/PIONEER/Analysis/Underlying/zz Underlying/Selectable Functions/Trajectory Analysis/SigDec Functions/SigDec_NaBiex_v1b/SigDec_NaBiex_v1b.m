%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SDEC,err] = SigDec_NaBiex_v1b(SCRPTipt,SDECipt)

Status2('done','Na Signal Decay Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SDEC.method = SDECipt.Func;
SDEC.T2f = str2double(SDECipt.('T2f'));
SDEC.T2s = str2double(SDECipt.('T2s'));
SDEC.TE = str2double(SDECipt.('TE'));

Status2('done','',2);
Status2('done','',3);
