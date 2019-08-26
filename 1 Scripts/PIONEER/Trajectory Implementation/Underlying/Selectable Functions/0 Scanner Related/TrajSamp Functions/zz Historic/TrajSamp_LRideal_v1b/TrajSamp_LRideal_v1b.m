%=========================================================
% (v1b)
%       - update for RWSUI_BA
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_LRideal_v1b(SCRPTipt,TSMPipt)

Status2('done','Get Trajectory Sampling Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.startfrac = str2double(TSMPipt.('StartFrac'));
TSMP.oversamp = str2double(TSMPipt.('OverSamp'));

Status2('done','',2);
Status2('done','',3);

