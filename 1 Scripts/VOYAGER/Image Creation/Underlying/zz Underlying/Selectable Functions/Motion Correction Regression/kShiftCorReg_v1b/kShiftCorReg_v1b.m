%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,KSHFTCOR,err] = kShiftCorMSYB_v1a(SCRPTipt,KSHFTCORipt)

Status2('busy','kShift Correction info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
KSHFTCOR.method = KSHFTCORipt.Func;

Status2('done','',2);
Status2('done','',3);

