%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,SYSRESP,err] = SysResp_Testing_v1a(SCRPTipt,SYSRESPipt)

Status2('busy','Get SysResp Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
SYSRESP.method = SYSRESPipt.Func;

Status2('done','',2);
Status2('done','',3);