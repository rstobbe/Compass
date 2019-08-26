%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,CLR,err] = Colour_Green_v1a(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   

Status2('done','',3);