%=========================================================
% (v2a)
%       - 
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_LRideal_v2a(SCRPTipt,TSMPipt)

Status2('done','Get Trajectory Sampling Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.startfrac = str2double(TSMPipt.('StartFrac'));
TSMP.dwell= str2double(TSMPipt.('Dwell'));

Status2('done','',2);
Status2('done','',3);

