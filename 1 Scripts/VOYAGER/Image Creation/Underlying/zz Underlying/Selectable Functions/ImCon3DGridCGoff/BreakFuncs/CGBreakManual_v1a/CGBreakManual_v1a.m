%=========================================================
% (v1a) 
%  
%=========================================================

function [SCRPTipt,BRK,err] = CGBreakManual_v1a(SCRPTipt,BRKipt)

Status2('busy','Get CG Break Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
BRK.method = BRKipt.Func;

Status2('done','',2);
Status2('done','',3);
