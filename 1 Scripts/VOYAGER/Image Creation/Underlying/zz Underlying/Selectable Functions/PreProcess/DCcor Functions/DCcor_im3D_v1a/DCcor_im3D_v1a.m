%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,DCCOR,err] = DCcor_im3D_v1a(SCRPTipt,DCCORipt)

Status2('busy','Image based DC correction',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
DCCOR.method = DCCORipt.Func;

Status2('done','',2);
Status2('done','',3);







