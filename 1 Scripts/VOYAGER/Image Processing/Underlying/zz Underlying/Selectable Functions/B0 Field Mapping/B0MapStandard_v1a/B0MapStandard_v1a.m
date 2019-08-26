%===========================================
% (v1a)
%   
%===========================================

function [SCRPTipt,B0MAP,err] = B0MapStandard_v1a(SCRPTipt,B0MAPipt)

Status2('done','B0 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B0MAP.method = B0MAPipt.Func;
B0MAP.maskval = str2double(B0MAPipt.('Mask'));
B0MAP.tediff = B0MAPipt.('TeDiff');

Status2('done','',2);
Status2('done','',3);

