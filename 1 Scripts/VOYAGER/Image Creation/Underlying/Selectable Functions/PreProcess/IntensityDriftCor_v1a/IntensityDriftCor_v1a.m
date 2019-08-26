%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,PREP,err] = IntensityDriftCor_v1a(SCRPTipt,PREPipt)

Status2('busy','Get Pre Processing Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PREP.method = PREPipt.Func;

Status2('done','',2);
Status2('done','',3);









