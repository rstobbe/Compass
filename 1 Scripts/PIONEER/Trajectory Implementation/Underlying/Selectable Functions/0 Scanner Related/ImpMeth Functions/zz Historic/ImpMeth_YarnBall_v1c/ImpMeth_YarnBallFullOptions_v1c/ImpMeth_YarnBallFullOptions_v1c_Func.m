%==================================================
% 
%==================================================

function [IMPMETH,err] = ImpMeth_YarnBallOptionFull_v1c_Func(IMPMETH,INPUT)

func = str2func('ImpMeth_YarnBall_v1c_Func');           
[IMPMETH,err] = func(IMPMETH,INPUT);

