%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = IntenseMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.absthresh = str2double(MASKipt.('AbsThresh'));

Status2('done','',2);
Status2('done','',3);

