%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,MASK,err] = CreateRoiFromExternalMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Create Roi from External Mask',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MASK.method = MASKipt.Func;

Status2('done','',2);
Status2('done','',3);







