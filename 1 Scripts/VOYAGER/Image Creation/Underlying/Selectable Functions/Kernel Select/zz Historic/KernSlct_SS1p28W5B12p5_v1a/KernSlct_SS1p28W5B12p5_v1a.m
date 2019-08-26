%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,KSEL,err] = KernSlct_SS1p28W5B12p5_v1a(SCRPTipt,KSELipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSEL.method = KSELipt.Func;
KSEL.kern = 'KBCw5b12p5ss1p28';

Status2('done','',2);
Status2('done','',3);









