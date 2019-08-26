%===========================================
% (v1d)
%      - Zero to Max
%===========================================

function [SCRPTipt,KSMP,err] = kSampGrdCUDAwOffResE_v1d(SCRPTipt,KSMPipt)

Status2('busy','Get Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;

Status2('done','',2);
Status2('done','',3);

