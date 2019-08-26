%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,SDEC,err] = SigDec_ArbBiex_v1a(SCRPTipt,SDECipt)

Status2('done','Arbitrary Biexponential Signal Decay',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
SDEC.method = SDECipt.Func;
SDEC.T2f = str2double(SDECipt.('T2f'));
SDEC.T2s = str2double(SDECipt.('T2s'));
SDEC.pT2f = str2double(SDECipt.('pT2f'))/100;
SDEC.pT2s = str2double(SDECipt.('pT2s'))/100;
SDEC.TE = str2double(SDECipt.('TE'));

Status2('done','',2);
Status2('done','',3);
