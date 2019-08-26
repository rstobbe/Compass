%=========================================================
% (v3g)
%       - Siemens needs to acquire an even number of points
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensLR_v3g(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.minbaseoversamp = str2double(TSMPipt.('MinBaseOverSamp'));
TSMP.sysoversamp = str2double(TSMPipt.('SysOverSamp'));

Status2('done','',2);
Status2('done','',3);