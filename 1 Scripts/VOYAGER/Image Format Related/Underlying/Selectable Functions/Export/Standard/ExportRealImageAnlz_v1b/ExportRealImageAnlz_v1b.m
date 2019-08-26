%=========================================================
% (v1b)
%       - output orientation change
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportRealImageAnlz_v1b(SCRPTipt,EXPORTipt)

Status2('done','Get Export Analyze Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT.method = EXPORTipt.Func;

Status2('done','',2);
Status2('done','',3);

