%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,KSEL,err] = KernSlct_SS2p0W2_v1a(SCRPTipt,KSELipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSEL.method = KSELipt.Func;
KSEL.kern = 'KBCw2b9ss2';               

Status2('done','',2);
Status2('done','',3);









