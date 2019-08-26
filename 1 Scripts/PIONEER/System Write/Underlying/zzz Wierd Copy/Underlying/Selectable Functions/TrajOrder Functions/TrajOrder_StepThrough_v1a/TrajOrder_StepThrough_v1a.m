%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,TORD,err] = TrajOrder_StepThrough_v1a(SCRPTipt,TORDipt)

Status2('busy','Write Trajectory Order',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TORD.method = TORDipt.Func;
TORD.step = str2double(TORDipt.('Step'));

Status2('done','',2);
Status2('done','',3);









