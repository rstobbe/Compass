%=====================================================
% (v1b)
%       - options update
%=====================================================

function [SCRPTipt,FIT,err] = Fit3DegShimCoils4z_v1b(SCRPTipt,FITipt)

Status2('busy','Get Fitting Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FIT.method = FITipt.Func;

Status2('done','',2);
Status2('done','',3);







