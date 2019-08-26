%=========================================================
% (v1b)
%     - include projection undersample in naming
%=========================================================

function [SCRPTipt,WRTP,err] = WrtParamLR_Siemens_v1b(SCRPTipt,WRTPipt)

Status2('busy','Write Gradient Parameter File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTP.method = WRTPipt.Func;

Status2('done','',2);
Status2('done','',3);
