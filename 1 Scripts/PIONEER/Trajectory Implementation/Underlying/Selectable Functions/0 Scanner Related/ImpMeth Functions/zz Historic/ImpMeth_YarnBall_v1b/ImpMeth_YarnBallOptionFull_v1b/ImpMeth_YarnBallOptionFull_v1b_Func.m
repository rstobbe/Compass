%==================================================
% 
%==================================================

function [IMPMETH,err] = ImpMeth_YarnBallOptionFull_v1b_Func(IMPMETH,INPUT)

func = str2func('ImpMeth_YarnBall_v1b_Func');           
[IMPMETH,err] = func(IMPMETH,INPUT);

