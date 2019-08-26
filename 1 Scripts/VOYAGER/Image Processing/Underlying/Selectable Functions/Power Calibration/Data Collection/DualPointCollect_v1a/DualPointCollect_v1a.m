%=========================================================
% (v1a)
%   
%=========================================================

function [SCRPTipt,DATCOL,err] = PointCollect_v1a(SCRPTipt,DATCOLipt)

Status2('busy','Collect Data',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
DATCOL.method = DATCOLipt.Func;

Status2('done','',2);
Status2('done','',3);

