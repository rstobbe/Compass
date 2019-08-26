%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,BASE,err] = AbsCombine_v1a(SCRPTipt,BASEipt)

Status2('busy','Create Base Image for Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
BASE.method = BASEipt.Func;

Status2('done','',2);
Status2('done','',3);

