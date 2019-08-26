%=========================================================
% 
%=========================================================

function [SCRPTipt,B0,err] = B0osc47Add_v1a(SCRPTipt,B0ipt)

Status2('busy','Get B0 Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
B0.method = B0ipt.Func;

Status2('done','',2);
Status2('done','',3);


