%=====================================================
% (v1d) 
%      - extra data point drop at centre
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_Standard_v1d(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.cenpntdrop = str2double(KSMPipt.('ExtraPntDrop'));

Status2('done','',2);
Status2('done','',3);

