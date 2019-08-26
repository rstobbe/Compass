%==================================================
% (v1c)
%   - update for function splitting
%==================================================

function [SCRPTipt,ACC,err] = Acc_None_v1c(SCRPTipt,ACCipt)

Status2('busy','Get Acceleration Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

ACC = struct();