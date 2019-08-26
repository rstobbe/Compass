%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportImageDicom_v1a(SCRPTipt,EXPORTipt)

Status2('done','Get Export Dicom Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT.method = EXPORTipt.Func;

Status2('done','',2);
Status2('done','',3);

