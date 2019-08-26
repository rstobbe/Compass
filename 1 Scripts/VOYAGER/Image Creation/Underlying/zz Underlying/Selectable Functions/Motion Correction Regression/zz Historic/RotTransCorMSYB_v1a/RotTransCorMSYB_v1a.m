%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,ROTTRANSCOR,err] = RotTransCorMSYB_v1a(SCRPTipt,ROTTRANSCORipt)

Status2('busy','Rotation and Translation Correction info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ROTTRANSCOR.method = ROTTRANSCORipt.Func;
ROTTRANSCOR.imthresh = str2double(ROTTRANSCORipt.('RelThresh'));

Status2('done','',2);
Status2('done','',3);

