%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcor_median2D_v1a(SCRPTipt,DCCORipt)

Status2('busy','DC correct FID',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DCCOR.method = DCCORipt.Func;

Status2('done','',2);
Status2('done','',3);







