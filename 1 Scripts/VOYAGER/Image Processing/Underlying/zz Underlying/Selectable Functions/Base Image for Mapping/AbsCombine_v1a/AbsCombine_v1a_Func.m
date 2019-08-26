%===========================================
% 
%===========================================

function [BASE,err] = AbsCombine_v1a_Func(BASE,INPUT)

Status2('busy','Get Base Image for Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
sz = size(INPUT.Im);
if length(sz) == 4
    BASE.Im = sum(abs(INPUT.Im),4);
elseif length(sz) == 5
    BaseIm = squeeze(sum(abs(INPUT.Im),4));
    BASE.Im = sum(abs(BaseIm),4);
end

Status2('done','',2);
Status2('done','',3);

