%====================================================
% (v1b)
%   - include Radial Evolution function
%====================================================

function [SCRPTipt,CLR,err] = Colour_GreenIO_v1b(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   

Status2('done','',3);