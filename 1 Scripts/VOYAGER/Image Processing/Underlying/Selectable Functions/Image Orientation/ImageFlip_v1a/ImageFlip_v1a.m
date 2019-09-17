%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,ORNT,err] = ImageFlip_v1a(SCRPTipt,ORNTipt)

Status2('busy','Flip Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Return
%------------------------------------------
ORNT.method = ORNTipt.Func;
ORNT.flip = ORNTipt.('Flip');

Status2('done','',2);
Status2('done','',3);

