%=========================================================
% (v1a)
%   
%=========================================================

function[SCRPTipt,SCRPTGBL,WRTSYS,err] = NoWrite_v1a(SCRPTipt,SCRPTGBL,WRTSYSipt,RWSUI)

Status2('busy','No Write',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTSYS.method = WRTSYSipt.Func;

Status2('done','',2);
Status2('done','',3);
