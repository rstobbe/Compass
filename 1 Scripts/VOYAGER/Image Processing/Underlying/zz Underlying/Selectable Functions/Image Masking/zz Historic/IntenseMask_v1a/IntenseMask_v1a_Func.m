%===========================================
% 
%===========================================

function [MASK,err] = IntenseMask_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
clear INPUT;

%---------------------------------------------
% Intensity Mask
%---------------------------------------------
Mask = abs(Im);
Mask(Mask < MASK.absthresh) = NaN;
Mask(Mask >= MASK.absthresh) = 1;

%---------------------------------------------
% Return
%---------------------------------------------
MASK.Mask = Mask;

Status2('done','',2);
Status2('done','',3);

