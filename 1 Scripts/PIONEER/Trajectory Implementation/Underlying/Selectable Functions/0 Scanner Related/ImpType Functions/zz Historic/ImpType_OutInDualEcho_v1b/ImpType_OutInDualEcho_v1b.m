%====================================================
% (v1b)
%   - update to make work...
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_OutInDualEcho_v1b(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

IMPTYPE.method = IMPTYPEipt.Func;   
IMPTYPE.maxradderivative = str2double(IMPTYPEipt.('MaxRadEndDeriv'));
IMPTYPE.radslowfact = str2double(IMPTYPEipt.('RadSlowFact'));
IMPTYPE.spinslowfact = str2double(IMPTYPEipt.('SpinSlowFact'));
IMPTYPE.postdelay = str2double(IMPTYPEipt.('PostDelay'));

Status2('done','',3);