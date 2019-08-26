%=========================================================
% (v1a)
%    
%=========================================================

function [SCRPTipt,ALGN,err] = AlignMultiImages_v1a(SCRPTipt,ALGNipt)

Status2('busy','Align Multiple Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;

Status2('done','',2);
Status2('done','',3);

