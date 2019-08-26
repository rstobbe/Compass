%=========================================================
% (v1d)
%       - Complex
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportComplexImageNII_v1d(SCRPTipt,EXPORTipt)

Status2('done','Export Nifti',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT.method = EXPORTipt.Func;
EXPORT.multivol = str2double(EXPORTipt.MultipleVols);

Status2('done','',2);
Status2('done','',3);

