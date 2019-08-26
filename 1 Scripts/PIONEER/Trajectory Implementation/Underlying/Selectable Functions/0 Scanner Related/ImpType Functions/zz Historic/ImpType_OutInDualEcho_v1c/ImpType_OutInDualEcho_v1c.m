%====================================================
% (v1c)
%   - Design stuff now removed
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_OutInDualEcho_v1c(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

IMPTYPE.method = IMPTYPEipt.Func;   

Status2('done','',3);