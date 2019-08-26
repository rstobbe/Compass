%=====================================================
% 
%=====================================================

function [SCALE,err] = ImScaleSimulation2_v1a_Func(SCALE,INPUT)

Status2('busy','Scale',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SCALE.Im = INPUT.Im/1000;


Status2('done','',2);
Status2('done','',3);






