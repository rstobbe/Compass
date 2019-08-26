%=========================================================
% (v3b)
%       - start TPIstandard_v3b
%=========================================================

function [SCRPTipt,TSMP,err] = TrajSamp_SiemensTPI_v3b(SCRPTipt,TSMPipt)

Status2('busy','Get Trajectory Sampling Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TSMP.method = TSMPipt.Func;
TSMP.reloversamp = str2double(TSMPipt.('RelOverSamp'));
TSMP.startsteps = str2double(TSMPipt.('Start'));

Status2('done','',2);
Status2('done','',3);