%=========================================================
% (v1a)
%     - allow arrays of images and image arrays
%     - coregister to first of first
%=========================================================

function [SCRPTipt,ALGN,err] = AlignImagesThroughArray_v1a(SCRPTipt,ALGNipt)

Status2('busy','Align Images Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;

Status2('done','',2);
Status2('done','',3);

