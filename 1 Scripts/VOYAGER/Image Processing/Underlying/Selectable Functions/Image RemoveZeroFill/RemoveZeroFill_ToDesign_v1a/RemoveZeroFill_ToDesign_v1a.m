%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,ZF,err] = RemoveZeroFill_ToDesign_v1a(SCRPTipt,ZFipt)

Status2('busy','Remove ZeroFill',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ZF.method = ZFipt.Func;

Status2('done','',2);
Status2('done','',3);







