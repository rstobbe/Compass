%=========================================================
% (v1a)
%       -
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_IdealLR_v1a(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.oversamp = str2double(TSMPipt.('OverSamp'));

Status2('done','',2);
Status2('done','',3);