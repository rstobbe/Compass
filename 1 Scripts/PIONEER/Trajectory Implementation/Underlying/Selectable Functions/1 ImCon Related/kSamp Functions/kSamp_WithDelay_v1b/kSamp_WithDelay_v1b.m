%=====================================================
% (v1b) 
%      - switch to 'Signal-Delay'
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_WithDelay_v1b(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.delay = str2double(KSMPipt.('SigDelay'));

Status2('done','',2);
Status2('done','',3);

