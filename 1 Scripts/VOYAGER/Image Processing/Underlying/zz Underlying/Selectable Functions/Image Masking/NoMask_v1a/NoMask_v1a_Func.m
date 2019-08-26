%===========================================
% 
%===========================================

function [MASK,err] = NoMask_v1a_Func(MASK,INPUT)

Status2('busy','No Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = [];

Status2('done','',2);
Status2('done','',3);

