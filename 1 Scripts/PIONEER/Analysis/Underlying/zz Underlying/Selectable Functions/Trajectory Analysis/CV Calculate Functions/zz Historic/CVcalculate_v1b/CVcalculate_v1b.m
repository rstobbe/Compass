%===========================================
% (v1b)
%    - input change
%===========================================

function [SCRPTipt,CVCALC,err] = CVcalculate_v1b(SCRPTipt,CVCALCipt)

Status2('busy','Calculate Correlation Volume',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
CVCALC.method = CVCALCipt.Func;

Status2('done','',3);





