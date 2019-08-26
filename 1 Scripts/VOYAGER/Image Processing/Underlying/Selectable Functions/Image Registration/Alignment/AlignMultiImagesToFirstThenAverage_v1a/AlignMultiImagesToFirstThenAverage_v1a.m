%=========================================================
% (v1a)
%    
%=========================================================

function [SCRPTipt,ALGN,err] = AlignMultiImagesToFirstThenAverage_v1a(SCRPTipt,ALGNipt)

Status2('busy','Align Multiple Images To First Then Average',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ALGN.method = ALGNipt.Func;

Status2('done','',2);
Status2('done','',3);

