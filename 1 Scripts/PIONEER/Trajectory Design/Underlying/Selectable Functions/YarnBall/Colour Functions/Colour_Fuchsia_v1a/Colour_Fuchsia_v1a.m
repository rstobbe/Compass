%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,CLR,err] = Colour_Pink_v1a(SCRPTipt,CLRipt)

Status2('busy','Get Colour',3);

err.flag = 0;
err.msg = '';

CLR.method = CLRipt.Func;   
CLR.overspin = str2double(CLRipt.('OverSpin'));

Status2('done','',3);