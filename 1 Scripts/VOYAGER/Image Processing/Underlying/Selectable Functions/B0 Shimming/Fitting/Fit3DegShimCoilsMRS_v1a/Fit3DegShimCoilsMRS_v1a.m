%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,FIT,err] = Fit3DegShimCoilsMRS_v1a(SCRPTipt,FITipt)

Status2('busy','Get Fitting Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
FIT.method = FITipt.Func;
FIT.h1freq = str2double(FITipt.('H1freq'));

Status2('done','',2);
Status2('done','',3);







