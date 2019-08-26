%=====================================================
% (v1a)
%      
%=====================================================

function [SCRPTipt,KSEL,err] = KernSlct_2p5_v1a(SCRPTipt,KSELipt)

Status2('busy','Get Scale Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSEL.method = KSELipt.Func;

%KSEL.kern = 'KBCw4b18ss2p5';
%KSEL.kern = 'KBCw4b20ss2p5';
%KSEL.kern = 'KBCw4b22ss2p5';
KSEL.kern = 'KBCw4b24ss2p5';                % think this is a good one

Status2('done','',2);
Status2('done','',3);









