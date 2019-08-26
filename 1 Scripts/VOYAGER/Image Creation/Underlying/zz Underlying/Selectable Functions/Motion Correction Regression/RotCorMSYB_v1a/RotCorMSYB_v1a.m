%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,ROTCOR,err] = RotCorMSYB_v1a(SCRPTipt,ROTCORipt)

Status2('busy','Rotation Correction info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ROTCOR.method = ROTCORipt.Func;
ROTCOR.imthresh = str2double(ROTCORipt.('RelThresh'));

Status2('done','',2);
Status2('done','',3);

