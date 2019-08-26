%=========================================================
% (v1a)
%   
%=========================================================

function[SCRPTipt,SCRPTGBL,WRTSHIM,err] = WriteShimV_v1a(SCRPTipt,SCRPTGBL,WRTSHIMipt,RWSUI)

Status2('busy','Write Shim File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTSHIM.method = WRTSHIMipt.Func;

Status2('done','',2);
Status2('done','',3);
