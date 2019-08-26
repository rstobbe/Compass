%=====================================================
% (v1b) 
%      - Fix indication of sampling timing
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_Option1_v1b(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.delay = str2double(KSMPipt.('SigDelay'));
KSMP.cenpntdrop = str2double(KSMPipt.('ExtraPntDrop'));

Status2('done','',2);
Status2('done','',3);

