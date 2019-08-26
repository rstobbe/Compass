%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,WRTG,err] = WrtGrad_LRSiemens_v1a(SCRPTipt,WRTGipt)

Status2('busy','Write Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTG.method = WRTGipt.Func;

Status2('done','',2);
Status2('done','',3);
