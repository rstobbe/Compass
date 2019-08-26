%=====================================================
% 
%=====================================================

function [SCALE,err] = ImScaleLogMag_v1a_Func(SCALE,INPUT)

Status2('busy','Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = abs(INPUT.Im);
Im = SCALE.range*Im/max(Im(:));
Im = log10(Im);
Im(Im<0) = 0;
SCALE.Im = Im;

Status2('done','',2);
Status2('done','',3);






