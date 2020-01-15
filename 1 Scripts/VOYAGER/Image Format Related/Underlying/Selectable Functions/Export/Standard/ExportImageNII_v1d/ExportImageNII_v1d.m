%=========================================================
% (v1d)
%       - Try to fix
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportImageNII_v1d(SCRPTipt,EXPORTipt)

Status2('done','Export Nifti',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT.method = EXPORTipt.Func;
EXPORT.multivol = str2double(EXPORTipt.MultipleVols);
EXPORT.datatype = EXPORTipt.('DataType');

Status2('done','',2);
Status2('done','',3);

