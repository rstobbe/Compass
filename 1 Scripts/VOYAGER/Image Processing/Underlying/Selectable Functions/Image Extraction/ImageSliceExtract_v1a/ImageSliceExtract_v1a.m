%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,SEXT,err] = ImageSliceExtract_v1a(SCRPTipt,SEXTipt)

Status2('busy','Images Slice Extract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
SEXT.method = SEXTipt.Func;
SEXT.ornt = SEXTipt.('Orientation');
SEXT.slice = str2double(SEXTipt.('Slice'));

Status2('done','',2);
Status2('done','',3);

