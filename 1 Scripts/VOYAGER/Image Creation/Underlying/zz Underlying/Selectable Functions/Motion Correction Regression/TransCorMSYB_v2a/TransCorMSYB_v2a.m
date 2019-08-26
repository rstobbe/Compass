%=========================================================
% (v2a)
%       - v2 (only middle line in centre cube)
%=========================================================

function [SCRPTipt,TRANSCOR,err] = TransCorMSYB_v2a(SCRPTipt,TRANSCORipt)

Status2('busy','Translation Correction info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
TRANSCOR.method = TRANSCORipt.Func;

Status2('done','',2);
Status2('done','',3);

