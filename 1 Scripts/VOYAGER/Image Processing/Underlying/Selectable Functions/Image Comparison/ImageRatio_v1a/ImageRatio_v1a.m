%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,SUBT,err] = ImageRatio_v1a(SCRPTipt,SUBTipt)

Status2('busy','Divide Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
SUBT.method = SUBTipt.Func;

Status2('done','',2);
Status2('done','',3);

