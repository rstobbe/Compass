%=====================================================
% (v1a)
%       -
%=====================================================

function [SCRPTipt,ZF,err] = ZeroFill_FactorMaintainPos_v1a(SCRPTipt,ZFipt)

Status2('busy','Get ZeroFill Info',2);
Status2('done','',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ZF.method = ZFipt.Func;
ZF.factor = ZFipt.('FillFactor');

Status2('done','',2);
Status2('done','',3);







