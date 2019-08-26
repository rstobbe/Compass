%=========================================================
% 
%=========================================================

function [STRT,err] = CGStartPrevIm_v1a_Func(STRT,INPUT)

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
if strcmp(STRT.useprev,'Yes')
    STRT.Im = STRT.IMG.Im;
else
    STRT.Im = INPUT.Im;
end





