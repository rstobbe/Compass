%=====================================================
% (v1c)
%       - Defined Symmetric Filter 
%=====================================================

function [SCRPTipt,RCOMB,err] = RcvComb_SingleSuper_v1c(SCRPTipt,RCOMBipt)

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







