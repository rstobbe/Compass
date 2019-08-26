%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASK,err] = ApplyCoregMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Apply Coregistered Mask',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.minval = str2double(MASKipt.('MinVal'));

Status2('done','',2);
Status2('done','',3);







