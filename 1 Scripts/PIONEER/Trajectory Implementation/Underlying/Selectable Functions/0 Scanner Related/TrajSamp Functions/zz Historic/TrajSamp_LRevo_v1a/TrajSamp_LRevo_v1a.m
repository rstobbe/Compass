%=========================================================
% (v1a)
%       
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_LRevo_v1a(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.startfrac0 = str2double(TSMPipt.('StartFrac'));

Status2('done','',2);
Status2('done','',3);