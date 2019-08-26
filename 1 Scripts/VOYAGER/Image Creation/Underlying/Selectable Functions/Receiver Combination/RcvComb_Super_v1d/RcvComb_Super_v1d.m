%=====================================================
% (v1d)
%       - No Change (just input name change)
%=====================================================

function [SCRPTipt,RCOMB,err] = RcvComb_Super_v1d(SCRPTipt,RCOMBipt)

Status2('busy','Get Receiver Combination Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
RCOMB.method = RCOMBipt.Func;
RCOMB.useexp = str2double(RCOMBipt.('RxProfFromExp'));
RCOMB.profres = str2double(RCOMBipt.('RxProfRes'));
RCOMB.proffilt = str2double(RCOMBipt.('RxProfFilt'));

Status2('done','',2);
Status2('done','',3);







