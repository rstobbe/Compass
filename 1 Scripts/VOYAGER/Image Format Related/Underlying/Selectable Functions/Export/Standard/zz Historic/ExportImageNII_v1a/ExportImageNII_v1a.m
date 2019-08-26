%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,EXPORT,err] = ExportImageNII_v1a(SCRPTipt,EXPORTipt)

Status2('done','Get Dicom Loading Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
EXPORT = struct();
EXPORT.multivol = str2double(EXPORTipt.MultipleVols);


Status2('done','',2);
Status2('done','',3);

