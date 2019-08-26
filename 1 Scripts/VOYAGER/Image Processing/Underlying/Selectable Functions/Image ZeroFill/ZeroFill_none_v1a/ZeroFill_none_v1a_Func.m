%=====================================================
%
%=====================================================

function [ZF,err] = ZeroFill_none_v1a_Func(ZF,INPUT)

Status2('busy','ZeroFill',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% No Zero-Fill - do nothing
%---------------------------------------------
ZF.Im = INPUT.Im;
ZF.ReconPars = INPUT.ReconPars;

Status2('done','',2);
Status2('done','',3);



