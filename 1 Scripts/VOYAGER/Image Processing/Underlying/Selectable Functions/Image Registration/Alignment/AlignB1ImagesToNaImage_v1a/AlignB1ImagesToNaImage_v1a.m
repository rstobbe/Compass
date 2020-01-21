%=========================================================
% (v1a)
%    - 
%=========================================================

function [SCRPTipt,ALGN,err] = AlignB1ImagesToNaImage_v1a(SCRPTipt,ALGNipt)

Status2('busy','Align B1 Images to 23Na Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;

Status2('done','',2);
Status2('done','',3);

