%=========================================================
% (v2a)
%       - v2 (only middle line in centre cube)
%=========================================================

function [SCRPTipt,TRANSCORREG,err] = TransCorReg_v2a(SCRPTipt,TRANSCORREGipt)

Status2('busy','Translation Correction info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
TRANSCORREG.method = TRANSCORREGipt.Func;

Status2('done','',2);
Status2('done','',3);

