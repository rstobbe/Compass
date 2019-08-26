%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,MOTCOR,err] = RotCorOnlyMSYBperftest_v1a(SCRPTipt,MOTCORipt)

Status2('busy','Perfect Rotation Correction for MSYB',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
MOTCOR.method = MOTCORipt.Func;

Status2('done','',2);
Status2('done','',3);

