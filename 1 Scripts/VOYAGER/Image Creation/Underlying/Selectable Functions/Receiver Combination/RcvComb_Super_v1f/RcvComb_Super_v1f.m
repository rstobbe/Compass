%=====================================================
% (v1f)
%       - rearrange again
%       - should be same output as v1d & v1e
%=====================================================

function [SCRPTipt,RCOMB,err] = RcvComb_Super_v1f(SCRPTipt,RCOMBipt)

Status2('busy','Get Receiver Combination Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RCOMB.method = RCOMBipt.Func;
RCOMB.profres = str2double(RCOMBipt.('RxProfRes'));
RCOMB.proffilt = str2double(RCOMBipt.('RxProfFilt'));

Status2('done','',2);
Status2('done','',3);







