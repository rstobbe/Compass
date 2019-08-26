%====================================================
% (v1c)
%   - more development
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_OutInOutMultiEcho_v1c(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

IMPTYPE.method = IMPTYPEipt.Func;   
IMPTYPE.maxradderivative = str2double(IMPTYPEipt.('MaxRadEndDeriv'));
IMPTYPE.radslowfact = str2double(IMPTYPEipt.('RadSlowFact'));
IMPTYPE.spinslowfact = str2double(IMPTYPEipt.('SpinSlowFact'));

Status2('done','',3);