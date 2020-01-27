%=========================================================
% (v1a)
%   - 
%=========================================================

function [SCRPTipt,MASK,err] = IntenseMaskRange_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.threshbot = str2double(MASKipt.('ThreshBot'));
MASK.threshtop = str2double(MASKipt.('ThreshTop'));

Status2('done','',2);
Status2('done','',3);

