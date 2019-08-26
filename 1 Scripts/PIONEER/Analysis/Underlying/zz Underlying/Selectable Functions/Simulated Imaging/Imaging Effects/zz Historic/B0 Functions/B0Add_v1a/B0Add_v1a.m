%=========================================================
% 
%=========================================================

function [SCRPTipt,B0,err] = B0Add_v1a(SCRPTipt,B0ipt)

Status2('busy','Get B0 Offset Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
B0.method = B0ipt.Func;
%B0.B0offset = str2double(B0ipt.('B0offset'));
B0.offres = str2double(B0ipt.('OffRes'));

Status2('done','',2);
Status2('done','',3);


