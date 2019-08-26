%===========================================
% (v1a)
%    
%===========================================

function [SCRPTipt,MAP,err] = R2Smap_v1b(SCRPTipt,MAPipt)

Status2('done','MAPmap Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
MAP.method = MAPipt.Func;

Status2('done','',2);
Status2('done','',3);

