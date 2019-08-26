%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = T1_CNRopt_v1a(SCRPTipt,TSTipt)

Status2('busy','CNR optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;

Status2('done','',2);
Status2('done','',3);

