%=====================================================
% (v1a) 
%      
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_Standard_v1a(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;

Status2('done','',2);
Status2('done','',3);

