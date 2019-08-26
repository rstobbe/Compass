%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASK,err] = ApplyExternalMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Apply Mask',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASK.method = MASKipt.Func;

Status2('done','',2);
Status2('done','',3);







