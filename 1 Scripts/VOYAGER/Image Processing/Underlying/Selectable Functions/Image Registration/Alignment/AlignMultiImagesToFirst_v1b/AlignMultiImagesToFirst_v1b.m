%=========================================================
% (v1b)
%    - Include SpaceRef
%=========================================================

function [SCRPTipt,ALGN,err] = AlignMultiImagesToFirst_v1b(SCRPTipt,ALGNipt)

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

