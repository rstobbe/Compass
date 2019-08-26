%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,MASK,err] = TiltedSagMask_v1a(SCRPTipt,MASKipt)

Status2('busy','Image Masking',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
MASK.method = MASKipt.Func;
MASK.displace(1) = str2double(MASKipt.('DispPost'));
MASK.displace(2) = str2double(MASKipt.('DispAnt'));

Status2('done','',2);
Status2('done','',3);

