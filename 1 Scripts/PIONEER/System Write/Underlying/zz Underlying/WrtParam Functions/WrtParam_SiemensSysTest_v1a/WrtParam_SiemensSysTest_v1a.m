%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,WRTP,err] = WrtParamSysTest_Siemens_v1a(SCRPTipt,WRTPipt)

Status2('busy','Write Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTP.method = WRTPipt.Func;

Status2('done','',2);
Status2('done','',3);
