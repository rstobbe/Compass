%=====================================================
% (v1b)
%       - input images  
%=====================================================

function [SCRPTipt,RCOMB,err] = RcvComb_MultiSuper_v1b(SCRPTipt,RCOMBipt)

Status2('busy','Get Receiver Combination Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RCOMB.method = RCOMBipt.Func;
RCOMB.lowresim = str2double(RCOMBipt.('LowResImage'));

Status2('done','',2);
Status2('done','',3);







