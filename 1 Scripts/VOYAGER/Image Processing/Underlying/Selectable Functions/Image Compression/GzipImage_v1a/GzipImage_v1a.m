%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,ZIP,err] = GzipImage_v1a(SCRPTipt,ZIPipt)

Status2('busy','Gzip Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
ZIP.method = ZIPipt.Func;

Status2('done','',2);
Status2('done','',3);

