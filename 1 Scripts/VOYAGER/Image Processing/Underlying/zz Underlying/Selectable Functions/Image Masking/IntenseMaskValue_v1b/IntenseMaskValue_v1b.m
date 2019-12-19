%=========================================================
% (v1b)
%   - include direction (finish)
%=========================================================

function [SCRPTipt,MASK,err] = IntenseMaskValue_v1b(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.thresh = str2double(MASKipt.('Thresh'));
MASK.direction = MASKipt.('Direction');

Status2('done','',2);
Status2('done','',3);

