%=====================================================
% (v1b)
%       - Correction
%=====================================================

function [SCRPTipt,PSTP,err] = Orient_VarianPA_v1b(SCRPTipt,PSTPipt)

Status2('busy','Get Orientation Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PSTP.method = PSTPipt.Func;

Status2('done','',2);
Status2('done','',3);







