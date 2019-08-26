%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,FAT,err] = Dixon_v1a(SCRPTipt,FATipt)

Status2('busy','Dixon Fat Suppression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
FAT.method = FATipt.Func;

Status2('done','',2);
Status2('done','',3);

