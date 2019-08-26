%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_None_v1a_Func(RCOMB,INPUT)

Status2('busy','RcvComb',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Do Nothing
%---------------------------------------------
RCOMB.Im = INPUT.Im;

Status2('done','',2);
Status2('done','',3);






