%=========================================================
% (v3e)
%       - Update tests for maximums
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_LRstandard_v3e(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.relfiltbw0 = str2double(TSMPipt.('RelFiltBW'));
TSMP.relsamp2filt0 = str2double(TSMPipt.('RelSamp2Filt'));
TSMP.startfrac0 = str2double(TSMPipt.('StartFrac'));
TSMP.sampbase = str2double(TSMPipt.('SampBase'));

Status2('done','',2);
Status2('done','',3);