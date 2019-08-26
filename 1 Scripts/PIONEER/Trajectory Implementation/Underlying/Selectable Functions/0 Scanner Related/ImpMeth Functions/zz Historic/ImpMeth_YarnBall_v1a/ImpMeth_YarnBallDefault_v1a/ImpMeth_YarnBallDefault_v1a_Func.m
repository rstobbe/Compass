%==================================================
% 
%==================================================

function [IMPMETH,err] = ImpMeth_YarnBallDefault_v1a_Func(IMPMETH,INPUT)

func = str2func('ImpMeth_YarnBall_v1a_Func');           
[IMPMETH,err] = func(IMPMETH,INPUT);

