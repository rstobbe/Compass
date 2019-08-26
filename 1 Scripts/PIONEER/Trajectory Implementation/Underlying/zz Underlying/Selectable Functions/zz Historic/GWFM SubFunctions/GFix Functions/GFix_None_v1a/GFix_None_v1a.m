%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,IGF,err] = GFix_None_v1a(SCRPTipt,IGFipt)

Status2('busy','Get GFix Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IGF.method = IGFipt.Func;

Status2('done','',2);
Status2('done','',3);