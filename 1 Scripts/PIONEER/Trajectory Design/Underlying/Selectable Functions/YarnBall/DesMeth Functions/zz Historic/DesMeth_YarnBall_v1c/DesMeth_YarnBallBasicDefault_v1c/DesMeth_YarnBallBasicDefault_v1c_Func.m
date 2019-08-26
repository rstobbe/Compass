%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_YarnBallBasicDefault_v1c_Func(DESMETH,INPUT)

func = str2func('DesMeth_YarnBall_v1c_Func');           
[DESMETH,err] = func(DESMETH,INPUT);

