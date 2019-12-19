%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,ORNT,err] = ImageShift_v1a(SCRPTipt,ORNTipt)

Status2('busy','Shift Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ORNT.method = ORNTipt.Func;
ORNT.shift = ORNTipt.('ShiftPix');

Status2('done','',2);
Status2('done','',3);

