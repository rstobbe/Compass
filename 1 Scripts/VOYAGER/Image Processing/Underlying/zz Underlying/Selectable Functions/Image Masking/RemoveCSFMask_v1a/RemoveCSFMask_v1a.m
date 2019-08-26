%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = RemoveCSFMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.threshold = str2double(MASKipt.('Threshold'));
MASK.direction = MASKipt.('Direction');
MASK.maskexpand = str2double(MASKipt.('MaskExpand'));

Status2('done','',2);
Status2('done','',3);

