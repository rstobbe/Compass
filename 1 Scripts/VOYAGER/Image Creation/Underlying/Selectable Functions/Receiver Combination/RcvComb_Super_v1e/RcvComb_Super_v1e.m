%=====================================================
% (v1e)
%       - rearrange (Gilbert 2007)
%       - Plot Coil Profiles
%       - should be same output as v1d
%       - drop multi-experiment (for now)
%=====================================================

function [SCRPTipt,RCOMB,err] = RcvComb_Super_v1e(SCRPTipt,RCOMBipt)

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







