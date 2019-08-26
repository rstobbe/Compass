%=========================================================
% (v3c)
%       - Update for maximum sampling BW
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensLR_v3c(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.reloversamp = str2double(TSMPipt.('RelOverSamp'));
TSMP.discard = str2double(TSMPipt.('Discard'));

Status2('done','',2);
Status2('done','',3);