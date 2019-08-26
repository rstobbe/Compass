%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_OutSingleEcho_v1a(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

IMPTYPE.method = IMPTYPEipt.Func;   

Status2('done','',3);