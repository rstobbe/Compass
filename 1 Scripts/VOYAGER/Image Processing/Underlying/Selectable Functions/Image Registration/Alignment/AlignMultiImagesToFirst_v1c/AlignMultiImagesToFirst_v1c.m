%=========================================================
% (v1c)
%    - add options
%=========================================================

function [SCRPTipt,ALGN,err] = AlignMultiImagesToFirst_v1c(SCRPTipt,ALGNipt)

Status2('busy','Align Multiple Images to First',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;
ALGN.config = ALGNipt.('Config');

Status2('done','',2);
Status2('done','',3);

