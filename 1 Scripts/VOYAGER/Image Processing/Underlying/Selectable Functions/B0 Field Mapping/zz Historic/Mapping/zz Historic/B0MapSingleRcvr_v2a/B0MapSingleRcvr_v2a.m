%===========================================
% (v2a)
%       - use 2 TEs to get sign right 
%===========================================

function [SCRPTipt,B0MAP,err] = B0MapSingleRcvr_v2a(SCRPTipt,B0MAPipt)

Status2('done','B0 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B0MAP.method = B0MAPipt.Func;

Status2('done','',2);
Status2('done','',3);

