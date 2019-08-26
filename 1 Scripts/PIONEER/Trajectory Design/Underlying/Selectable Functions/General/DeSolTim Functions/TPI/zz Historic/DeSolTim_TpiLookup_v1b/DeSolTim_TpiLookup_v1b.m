%====================================================
% (v1b)
%    - use DEs from above
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_TpiLookup_v1b(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

DESOL.method = DESOLipt.Func;

Status2('done','',2);
Status2('done','',3);