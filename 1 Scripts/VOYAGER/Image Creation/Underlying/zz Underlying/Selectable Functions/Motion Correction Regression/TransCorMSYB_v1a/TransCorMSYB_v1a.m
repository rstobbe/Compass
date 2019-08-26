%=========================================================
% (v1a)
%       - v1 (average of 9 lines in centre cube)
%=========================================================

function [SCRPTipt,TRANSCOR,err] = TransCorMSYB_v1a(SCRPTipt,TRANSCORipt)

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

