%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,MAP,err] = rMTmap_v1a(SCRPTipt,MAPipt)

Status2('done','Relative MT Map Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;

