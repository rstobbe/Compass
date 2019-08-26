%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,FILT,err] = Filter_none_v1a(SCRPTipt,FILTipt)

Status2('busy','Get Filtering Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FILT.method = FILTipt.Func;

Status2('done','',2);
Status2('done','',3);







