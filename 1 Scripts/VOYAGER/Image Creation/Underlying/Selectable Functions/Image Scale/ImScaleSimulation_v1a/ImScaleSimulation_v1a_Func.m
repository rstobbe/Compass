%=====================================================
% 
%=====================================================

function [SCALE,err] = ImScaleSimulation_v1a_Func(SCALE,INPUT)

Status2('busy','Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
scale = (INPUT.zf/INPUT.FID.CreateZf)^3;
scale = scale*INPUT.TORD.SdcOverSamp;

SCALE.Im = scale*INPUT.Im;


Status2('done','',2);
Status2('done','',3);






