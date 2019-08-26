%=========================================================
% (v3i)
%       - Make sure number of data points a multiple of 16 (for TIM)
%       - hardcode sysoversamp
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensLR_v3i(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.minbaseoversamp = str2double(TSMPipt.('MinBaseOverSamp'));
TSMP.sysoversamp = 1.25;

Status2('done','',2);
Status2('done','',3);