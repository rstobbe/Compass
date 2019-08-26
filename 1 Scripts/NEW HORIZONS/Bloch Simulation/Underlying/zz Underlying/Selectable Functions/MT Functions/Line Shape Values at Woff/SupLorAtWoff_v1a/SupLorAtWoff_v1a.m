%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,LINEFUNC,err] = SupLorAtWoff_v1a(SCRPTipt,LINEFUNCipt)

Status2('busy','Get Info for Super-Lorentzian Line Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
LINEFUNC.method = LINEFUNCipt.Func;
LINEFUNC.intN = str2double(LINEFUNCipt.('IntN'));

Status2('done','',2);
Status2('done','',3);
