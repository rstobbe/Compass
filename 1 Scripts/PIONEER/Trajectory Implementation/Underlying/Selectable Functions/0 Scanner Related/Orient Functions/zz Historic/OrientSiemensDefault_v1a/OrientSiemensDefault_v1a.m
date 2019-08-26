%====================================================
% (v1a)
%    
%====================================================

function [SCRPTipt,ORNT,err] = OrientSiemensDefault_v1a(SCRPTipt,ORNTipt)

Status2('busy','Orient Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ORNT.method = ORNTipt.Func;

Status2('done','',2);
Status2('done','',3);
