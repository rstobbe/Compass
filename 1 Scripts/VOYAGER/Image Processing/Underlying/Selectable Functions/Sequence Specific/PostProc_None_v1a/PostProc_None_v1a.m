%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,PSTP,err] = PostProc_None_v1a(SCRPTipt,PSTPipt)

Status2('busy','Get Post Processing Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Panel Input
%---------------------------------------------
PSTP.method = PSTPipt.Func;

Status2('done','',2);
Status2('done','',3);







