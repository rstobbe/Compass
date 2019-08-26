%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,B1MAP,err] = B1MapAFISiemens_v1a(SCRPTipt,B1MAPipt)

Status2('done','B1 Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
B1MAP.method = B1MAPipt.Func;
B1MAP.maskval = str2double(B1MAPipt.('Mask'));

Status2('done','',2);
Status2('done','',3);


