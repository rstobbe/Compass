%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,DUM,err] = Dummy_v1a(SCRPTipt,DUMipt)

Status2('busy','Dummy Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
DUM.method = DUMipt.Func;

Status2('done','',2);
Status2('done','',3);

