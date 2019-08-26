%=========================================================
% (v1d)
%       - Flix Flipping 
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportImageAnlz_v1d(SCRPTipt,EXPORTipt)

Status2('done','Get Export Analyze Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT.method = EXPORTipt.Func;
EXPORT.subset = EXPORTipt.('SubSet');
EXPORT.type = EXPORTipt.('Type');

Status2('done','',2);
Status2('done','',3);

