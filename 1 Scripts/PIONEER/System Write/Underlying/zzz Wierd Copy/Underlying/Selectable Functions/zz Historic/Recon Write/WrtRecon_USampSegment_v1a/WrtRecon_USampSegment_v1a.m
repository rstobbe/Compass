%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,RCNWRT,err] = ReconWrtStepThrough_v1a(SCRPTipt,RCNWRTipt)

Status2('busy','Write Reconstruction Data',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RCNWRT.method = RCNWRTipt.Func;
RCNWRT.step = str2double(RCNWRTipt.('Step'));

Status2('done','',2);
Status2('done','',3);









