%====================================================
% (v1f)
%   - turn around capability
%   - function is an input
%====================================================

function [SCRPTipt,CLR,err] = Colour_Green_v1f(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   

Status2('done','',3);