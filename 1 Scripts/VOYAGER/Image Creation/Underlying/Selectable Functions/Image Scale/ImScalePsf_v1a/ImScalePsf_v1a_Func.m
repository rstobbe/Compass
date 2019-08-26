%=====================================================
% 
%=====================================================

function [SCALE,err] = ImScalePsf_v1a_Func(SCALE,INPUT)

Status2('busy','Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SCALE.Im = 1000*INPUT.Im/max(abs(INPUT.Im(:)));


Status2('done','',2);
Status2('done','',3);






