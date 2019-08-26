%=========================================================
% (v3e)
%       - Sample bit beyond gradient delay (so can drop points)
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensLR_v3e(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.reloversamp0 = str2double(TSMPipt.('RelOverSamp'));

Status2('done','',2);
Status2('done','',3);